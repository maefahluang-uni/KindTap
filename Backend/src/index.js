require('dotenv').config();

const express = require('express');
const axios = require('axios');
const cors = require('cors');
const helmet = require('helmet');
const functions = require('firebase-functions');
const jwt = require('jsonwebtoken');
const cookieParser = require('cookie-parser');
const multer = require('multer');
const nodemailer = require('nodemailer');
const app = express();
app.use(cookieParser());
app.use(express.json());
app.use(cors());
app.use(helmet());

const firebaseConfig = require('../firebase-config.json');
const SHARE_EARN_LIMIT = 10; // 10 USD
const PORT = 3000; // process.env.PORT || 3000;
const MSG = function (message, option) {
  let object = {
    timestamp: Date.now(),
    message: message,
    ...option
  };
  return object;
};
app.get('/about', async (req, res) => {
  res.send({ version: 4 })
})

//////////////////////////////
// Firebase (Realtime Database) Init
//////////////////////////////
const admin = require('firebase-admin');
const serviceAccount = require('../firebase-service-account.json');
const { async } = require('@firebase/util');
const { error, profile, Console } = require('console');
const { throws } = require('assert');
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  //storageBucket: 'gs://mini-project-mobile-app-12b8e.appspot.com',
  databaseURL: "https://mini-project-mobile-app-12b8e-default-rtdb.asia-southeast1.firebasedatabase.app",
});
const db = admin.database();

//////////////////////////////
// Image Init
//////////////////////////////
const { Storage } = require('@google-cloud/storage');
const storage = new Storage({
  projectId: firebaseConfig.appId,
  keyFilename: 'firebase-service-account.json',
});
const upload = multer({ storage: multer.memoryStorage() });
function getImageExtensionFromBase64(base64String) {
  // Remove the data URL prefix (e.g., 'data:image/png;base64,')
  const base64WithoutPrefix = base64String.replace(/^data:image\/[a-zA-Z]+;base64,/, '');
  // Decode the base64 string into a Uint8Array
  const binaryString = atob(base64WithoutPrefix);
  const bytes = new Uint8Array(binaryString.length);
  for (let i = 0; i < binaryString.length; i++) {
      bytes[i] = binaryString.charCodeAt(i);
  }
  // Determine the file extension based on the file's magic number (initial bytes)
  let extension = null;
  if (bytes[0] === 0xFF && bytes[1] === 0xD8) {
      extension = 'jpg'; // JPEG image
  } else if (bytes[0] === 0x89 && bytes[1] === 0x50 && bytes[2] === 0x4E && bytes[3] === 0x47) {
      extension = 'png'; // PNG image
  } else if (bytes[0] === 0x47 && bytes[1] === 0x49 && bytes[2] === 0x46 && bytes[3] === 0x38) {
      extension = 'gif'; // GIF image
  } else if (bytes[0] === 0x52 && bytes[1] === 0x49 && bytes[2] === 0x46 && bytes[3] === 0x46 &&
             bytes[8] === 0x57 && bytes[9] === 0x45 && bytes[10] === 0x42 && bytes[11] === 0x50) {
      extension = 'webp'; // WEBP image
  } else if (bytes[0] === 0x00 && bytes[1] === 0x00 && bytes[2] === 0x01 && bytes[3] === 0x00) {
      extension = 'ico'; // ICO image
  }
  return extension;
}

//////////////////////////////
// Auth Init
//////////////////////////////
const requestProfile = async (email, password) => {
  try {
    const response = await axios.post(
      `https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=${firebaseConfig.apiKey}`,
      {
        email: email,
        password: password,
        returnSecureToken: true,
      }
    );
    let user = response.data;
    let user_data = await User_STORE.child(user.localId).get();
    let profile = {
      ...user, // from firestore Authentication
      "data": {
        ...user_data.val(), // from firestore Realtime Database
      }
    };
    return profile
  } catch (e) {}
  return undefined
}

//////////////////////////////
// User system
//////////////////////////////
const User_STORE = db.ref('user');
/* Use in flutter
  // login
  // logout
  // forgot-email
*/
app.post('/register', async (req, res) => {
  try {
    const { email, password } = req.body;
    const response = await axios.post(
      `https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=${firebaseConfig.apiKey}`,
      {
        email: email,
        password: password,
        returnSecureToken: true
      }
    );
    // Create user data in Realtime Database
    const localId = response.data.localId;
    await User_STORE.child(localId).set({
      balance: 0,
      display_name: email,
      address: "",
      email: email,
      profile_image: "",
    })
    ////////////////////////////////////////////
    res.status(201).send(MSG('Profile created successfully.', { localId: localId }));
  } catch (e) {
    try {
      let error = e.response.data.error;
      res.status(error.code).send(MSG(error.message));
    } catch (err) {
      res.status(400).send(MSG(err.toString()));
    }
  }
});
app.post('/profile', async (req, res) => {
  try {
    const { email, password } = req.body;
    const user = await requestProfile(email, password);
    let userData = await User_STORE.child(user.localId).get();
    let profile = {
      ...user, // from firestore Authentication
      "data": {
        ...userData.val(), // from firestore Realtime Database
      }
    };
    res.status(200).send(profile);
  } catch (e) {
    res.status(400).send(MSG(e.toString()));
  }
});
app.post('/edit-profile-image', async (req, res) => {
  try {
    const { email, password, image } = req.body;
    const user = await requestProfile(email, password);
    let IMAGE_URL = null;
    try {
      const imageBuffer = Buffer.from(image, 'base64');
      const fileExtension = getImageExtensionFromBase64(image);
      if (fileExtension) {
        // img
        if (image) {
          const storageBucket = storage.bucket("gs://mini-project-mobile-app-12b8e.appspot.com")
          const fileName = `${user.localId}-${Date.now()}.${fileExtension}`;
          const file = storageBucket.file(fileName);
          await file.save(imageBuffer);
          let image_signed_url = await file.getSignedUrl({
            action: 'read',
            expires: '01-01-2030', // Set expiration date as needed
          }).then(urls => urls[0]);
          IMAGE_URL = image_signed_url;
        }
      } else {
        throw new Error('Unable to determine file type.');
      }
    } catch(e) {
      res.status(400).send(MSG(e.toString()));
    }
    await User_STORE.child(user.localId).update({
      profile_image: IMAGE_URL
    });
    res.status(200).send(MSG('Profile image set successfully.'));
  } catch (e) {
    res.status(500).send(MSG(e.toString()));
  }
});
app.post('/edit-profile', async (req, res) => {
  try {
    const { email, password, input_address, input_display_name } = req.body;
    if (!((typeof(input_display_name) == "string") && (input_display_name.length >= 0) && (input_display_name.length <= 16))) {
      throw new Error("input_display_name must be string and length 0-16 characters");
    }
    if (!((typeof(input_address) == "string") && (input_address.length >= 0) && (input_address.length <= 8192))) {
      throw new Error("input_address must be string and length 0-8192 characters");
    }
    const user = await requestProfile(email, password);
    await User_STORE.child(user.localId).update({
      address: input_address,
      display_name: input_display_name,
    })
    res.status(200).send(MSG("Profile edited successfully."));
  } catch(e) {
    res.status(400).send(MSG(e.toString()));
  }
});

// 0637265985 ของไมค์ // 0947525272 ของกุ
// const generatePayload = require('promptpay-qr') 
// const qrcode = require('qrcode') 
// const fs = require('fs') 
// const mobileNumber = '063-726-5985' 
// const options = { type: 'svg', color: { dark: '#000', light: '#fff' } };
// app.get('/generate-qr', async (req, res) => {
//   let { amount } = req.query;
//   try {
//     amount = parseFloat(amount);
//     const payload = generatePayload(mobileNumber, { amount });
//     qrcode.toString(payload, options, (err, svg) => {
//         if (err) {
//           throw new Error(err);
//         }
//         fs.writeFileSync('./qr.svg', svg)
//         res.send(svg);
//     })
//   } catch (e) {
//     res.status(500).send(e.toString());
//   }
// });

const payment_STORE = db.ref('payment');
app.post('/claim-payment', async(req, res) => {
  try {
    // ส่ง เมล
    // ส่ง slip
    // admin คีย์ข้อมูล
    const { email, ref_no, amount } = req.query;
    const ref_no_sync_data = (await payment_STORE.child(ref_no).get()).val();
    console.log(ref_no_sync_data);
    if (!ref_no_sync_data) { // ref_no ไม่ซํ้ากัน claim ได้
      let find_localid, find_user;
      let user_list = (await User_STORE.once('value')).val();
      if (user_list) {
        // Looping through each item in the data
        for (var self_localid in user_list) {
          if (user_list.hasOwnProperty(self_localid)) {
            var user = user_list[self_localid];
            if (user.email == email) {
              find_localid = self_localid;
              find_user = user;
              break;
            }
          }
        }
      }
      if (find_localid) {
        await payment_STORE.child(ref_no).update({
          claimed: email,
          amount: amount,
        });
        await User_STORE.child(find_localid).update({
          balance: find_user.balance + amount,
        })
        res.status(200).send(MSG('Payment claimed successfully.'));
      } else {
        res.status(404).send(MSG('Not found email in database. (Process Claim Skipped)'));
      }
    } else {
      res.status(401).send(MSG('Someone claim this payment already.'));
    }
  } catch(e) {
    res.status(400).send(MSG(e.toString()));
  }
});
function intersectObjects(obj1, obj2) {
  const result = {};
  for (let key in obj1) {
    if (obj2.hasOwnProperty(key)) {
      result[key] = obj2[key];
    }
  }
  return result;
}
const Project_STORE = db.ref('project');
app.put('/donate', async (req, res) => {
  /*
    {
      "project_id": "", // string: (@AutoGenerated, Firebase)
      "price": 1 // >1 (Unit: $)
    }
  */
  try {
    const {
      project_id,
      price,
      email,
      password
    } = req.body
    const user = await requestProfile(email, password);
    if (price <= 0) {
      throw new Error("price must more than 0")
    }
    const TargetProject = Project_STORE.child(project_id); //db.ref(`/project/${project_id}`);
    if (!(await TargetProject.get()).val()) {
      throw new Error("not found project by project_id")
    }
    const TargetProject_duration = (await TargetProject.child('project_duration').once('value')).val() || Date.now();
    const TargetProject_goal = (await TargetProject.child('project_goal').once('value')).val() || 10;
    const TargetProject_balance = (await TargetProject.child('project_balance').once('value')).val() || 0;
    let TargetProject_share_ratio = (await TargetProject.child('project_share_ratio').once('value')).val() || 0;
    const TargetProject_share_holder = (await TargetProject.child('project_share_holder').once('value')).val() || {};
    if (Date.now() >= TargetProject_duration) {
      throw new Error("project ended");
    };
    const TargetProject_balance_to_complete_goal = Math.max(0, TargetProject_goal - TargetProject_balance);
    if (TargetProject_balance_to_complete_goal == 0) {
      throw new Error("project goal completed");
    };
    if (TargetProject_balance_to_complete_goal <= TargetProject_share_ratio) {
      TargetProject_share_ratio = 0
    }
    if (user.data.balance >= price) {
      const donate_price = Math.min(TargetProject_balance_to_complete_goal, price);
      if (Object.keys(TargetProject_share_holder).length == 0) {
        TargetProject_share_ratio = 0
      }
      let share_earn_value = donate_price * (TargetProject_share_ratio / 100);
      let result_donate_price = donate_price - share_earn_value;
      //////////////////////
      await User_STORE.child(user.localId).update({
        balance: user.data.balance - donate_price
      });
      // share system
      let all_user = (await User_STORE.once('value')).val() || {};
      let exist_holder = intersectObjects(TargetProject_share_holder, all_user);
      ////////////////////////////////////////////////////////////////
      let total_count_holder = Object.keys(exist_holder).length;
      const earn_per = share_earn_value / total_count_holder;
      let left_earn = share_earn_value;
      for (let holder_localId in exist_holder) {
        try {
          amount_to_earn_max = Math.max(0, SHARE_EARN_LIMIT - TargetProject_share_holder[holder_localId].earn)  // check if share earn more than 10USD (disable share to holder)
          amount_to_earn_max = Math.min(earn_per, amount_to_earn_max)
          exist_holder[holder_localId].balance = exist_holder[holder_localId].balance + amount_to_earn_max;
          TargetProject_share_holder[holder_localId].earn = TargetProject_share_holder[holder_localId].earn + amount_to_earn_max;
          left_earn = left_earn - amount_to_earn_max
        } catch(e) {}
      }
      await TargetProject.update({
        project_balance: TargetProject_balance + result_donate_price + left_earn,
      });
      await User_STORE.update(exist_holder);
      TargetProject_share_holder[user.localId] = TargetProject_share_holder[user.localId] || {
        recent_donate_time: Date.now(),
        earn: 0,
      }
      TargetProject_share_holder[user.localId].recent_donate_time = Date.now()
      await TargetProject.update({
        project_share_holder: TargetProject_share_holder,
      });
      // await User_STORE.child(user.localId).child("balance").update({
      //   donated
      // });
    } else {
      throw new Error("balance insufficient")
    }
    res.status(200).send(MSG("donated"));
  } catch (e) {
    res.status(400).send(MSG(e.toString()));
  }
});
app.post('/create-project', async (req, res) => {
  /*
    {
      // .init
      //"project_owner": "",
      //"project_balance": 0,
      // .req
      "project_name": "Test",
      "project_region": "Thailand",
      "project_image": "IMAGE_FORM_TYPE",
      "project_tags": ["Cat", "Dog"],
      "project_about": "",
      "project_social": "",
      "project_goal": 10, // >10 (Unit: $)
      "project_duration": 86400, // Seconds
      "project_share_ratio": 0 // 0,1,2,3,4,5 (Unit: %)
    }
  */
  try {
    let {
      email,
      password,
      //
      project_name,
      project_region,
      project_tags,
      project_about,
      project_social,
      project_goal,
      project_duration,
      project_share_ratio,
      project_image
    } = req.body
    project_share_ratio = parseInt(project_share_ratio);
    project_duration = Number(project_duration);
    project_goal = Number(project_goal);
    const user = await requestProfile(email, password);
    let IMAGE_URL = null;
    try {
      const imageBuffer = Buffer.from(project_image, 'base64');
      const fileExtension = getImageExtensionFromBase64(project_image);
      if (fileExtension) {
        // img
        if (project_image) {
          const storageBucket = storage.bucket("gs://mini-project-mobile-app-12b8e.appspot.com")
          const fileName = `${user.localId}-${Date.now()}.${fileExtension}`;
          const file = storageBucket.file(fileName);
          await file.save(imageBuffer);
          let project_image_signed_url = await file.getSignedUrl({
            action: 'read',
            expires: '01-01-2030', // Set expiration date as needed
          }).then(urls => urls[0]);
          IMAGE_URL = project_image_signed_url;
        }
      } else {
        throw new Error('Unable to determine file type.');
      }
    } catch(e) {
      res.status(400).send(MSG(e.toString()));
    }
    Project_STORE.push({
      project_owner: user.localId,
      project_balance: 0,
      //
      project_name,
      project_region,
      project_tags,
      project_about,
      project_social,
      project_goal,
      project_duration: Date.now() + (project_duration * 1000),
      project_share_ratio,
      project_image: IMAGE_URL,
      //
      project_share_holder: {
        [user.localId]: {
          recent_donate_time: Date.now(),
          earn: 0,
        }
      },
    }) // automatic generated project_id
    res.status(200).send(MSG("Create successfully!"));
  } catch (e) {
    res.status(400).send(MSG(e.toString()));
  }
});
app.get('/get-all-project', async (req, res) => {
  try {
    const ListOfProject = await Project_STORE.once('value');
    const ListOfUser = await User_STORE.once('value');
    let PROJECT_JSON_DATA = ListOfProject.toJSON();
    let USER_JSON_DATA = ListOfUser.toJSON();
    for (let proj_id in PROJECT_JSON_DATA) {
      let proj = PROJECT_JSON_DATA[proj_id];
      if (proj) {
        proj.project_owner_displayname = USER_JSON_DATA[proj.project_owner].display_name || "Anonymous"
        proj.project_owner_email = USER_JSON_DATA[proj.project_owner].email || "@Anonymous"
        let supporters = proj.project_share_holder
        if (supporters) { 
          for (let holder_id in supporters) {
            let who = supporters[holder_id];
            if (who) {
              who.holder_displayname = USER_JSON_DATA[holder_id].display_name || "Anonymous"
            }
          }
        }
      }
    }
    res.send(PROJECT_JSON_DATA);
    // เดวส่ง email
    // เดวส่ง display_name
    // แนบใน project
  } catch (e) {
    res.status(400).send(MSG(e.toString()));
  } 
});
app.get('/is-exist',  async (req, res) => {
  res.status(200);
})

///////////////////////////////////////////////////////////////////////////////////////////////////////

app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});

exports.api = functions.https.onRequest(app)

// npm start (localtest)
// npm run deploy (firebase)

// *If port was already use*
// Taskkill /IM node.exe /F
// npm run deploy (firebase)