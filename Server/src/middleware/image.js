import { bucket } from '../config/firebase.js';
import Multer from 'multer';
import config from '../config/index.js';
//import { getDownloadURL } from 'firebase-admin/storage';

const multer = Multer({
    storage: Multer.memoryStorage(),
    limits: {
      fileSize: 5 * 1024 * 1024 // no larger than 5mb, you can change as needed.
    }
});

async function uploadFile(file) {
    try{
        await bucket.makePublic();
        //스토리지에 저장
        const now = Date.now();
        const encodeName = encodeURIComponent(file.originalname);
        const destName = `${now}_${encodeName}`;
        await bucket.file(destName).save(file.buffer);
        await bucket.file(destName).makePublic();
        //url을 DB에 저장
        const encodeencodeName = encodeURIComponent(encodeName); 
        const nameinStorage = `${now}_${encodeencodeName}`;
        const url = `${config.originUrl}${nameinStorage}`;
        return url;
    }catch (error){
        //console.log(error);
        throw error;
    }
};

async function removeFile(fileName){
    try{
        const deocdeName = decodeURIComponent(fileName);
        if(bucket.file(deocdeName).exists){
            await bucket.file(deocdeName).delete();
        }
    }catch (error){
        //console.log(error);
        throw error;
    }
}

export {
    uploadFile, 
    multer,
    removeFile,
};