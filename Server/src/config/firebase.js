import config from './index.js';
import admin from 'firebase-admin';
import { getFirestore } from 'firebase-admin/firestore';
import { getAuth } from 'firebase-admin/auth';
import { getStorage } from 'firebase-admin/storage';

import serviceAccount from './firebase-adminsdk.json' assert { type: "json" };

const app = admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
    storageBucket: config.storageBucket
});

const fbDB = getFirestore(app);
const fbAuth = getAuth(app); 
const bucket = getStorage().bucket();

export { fbDB, fbAuth, bucket};