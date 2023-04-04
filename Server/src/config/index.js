import dotenv from "dotenv";

// Set the NODE_ENV to 'development' by default
process.env.NODE_ENV = process.env.NODE_ENV || 'development';

const envFound = dotenv.config();

if (envFound.error) {
    // This error should crash whole process
    throw new Error(envFound.error);
}

const {
    PORT,
    COOKIE_SECRET,
    STORAGE_BUCKET,
    ORIGIN_URL,
} = process.env;

export default {
    port: PORT,
    cookieSecret: COOKIE_SECRET,
    storageBucket:STORAGE_BUCKET,
    originUrl: ORIGIN_URL
};