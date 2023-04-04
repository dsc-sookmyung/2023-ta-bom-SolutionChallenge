import express from 'express';
import { userService } from "../service/index.js";

/**
 *  @route POST /user/:id
 *  @desc change user's information
 *  @access Private
 */
const updateUser = async (req, res) => {
    const { uid } = req.params;
    let file = req.file;
    try {
        if(req.body.data == undefined){
            throw new Error('⛔you must put data at least {} in body');
        }
        if (file.size > 5 * 1024 * 1024){
            throw new Error('⛔you must upload file smaller than 5MB');
        }
        const  newUserRecord = JSON.parse(req.body.data);
        const updateUser = await userService.updateUser(file, uid, newUserRecord);
        if (updateUser) {
            return res.status(200).json({
                status: 200,
                success: true,
                message: "유저 업데이트 성공",
                data: updateUser,
            });
        }
    }catch (error){
        console.log(error);
        res.status(400).json({
        status: 400,
        success: false,
        message: error.message,
    });
    }
};


/**
 *  @route GET /user/:id
 *  @desc change user's information
 *  @access Private
 */
const getUser = async (req, res) => {
    const { uid } = req.params;
    try {
        const getUser = await userService.getUser(uid);
        if (getUser) {
            return res.status(200).json({
                status: 200,
                success: true,
                message: "유저 정보 얻기 성공",
                data: getUser,
            });
        }
    }catch (error){
        console.log(error);
        res.status(400).json({
        status: 400,
        success: false,
        message: error.message,
    });
    }
};

/**
 *  @route POST /user/loc/:id
 *  @desc change user's information
 *  @access Private
 */
const postUserLocation = async (req, res) => {
    const { uid } = req.params;
    const data = req.body;
    try {
        const postUserLocation = await userService.postUserLocation(uid, data);
        if (postUserLocation) {
            return res.status(200).json({
                status: 200,
                success: true,
                message: "유저 위치 정보 생성 성공",
                data: postUserLocation,
            });
        }
    }catch (error){
        console.log(error);
        res.status(400).json({
        status: 400,
        success: false,
        message: error.message,
    });
    }
};

/**
 *  @route GET /user/loc/:id
 *  @desc change user's information
 *  @access Private
 */
const getUserLocation = async (req, res) => {
    const { uid } = req.params;
    try {
        const getUserLocation = await userService.getUserLocation(uid);
        if (postUserLocation) {
            return res.status(200).json({
                status: 200,
                success: true,
                message: "유저 위치 정보 읽기 성공",
                data: getUserLocation,
            });
        }
    }catch (error){
        console.log(error);
        res.status(400).json({
        status: 400,
        success: false,
        message: error.message,
    });
    }
};


export default {
    updateUser,
    getUser,
    postUserLocation,
    getUserLocation,
};