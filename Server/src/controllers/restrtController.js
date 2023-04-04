import express from 'express';
import { restrtService } from "../service/index.js";

/**
 *  @route POST /restrt
 *  @desc POST restaurant data
 *  @access Private
 */
const postRestrt = async (req, res) => {
    const data = req.body;
    let file = req.file;
    try {
        const postRestrt = await restrtService.postRestrt(file, data);
        return res.status(200).json({
            status: 200,
            success: true,
            message: "음식점 정보 생성 성공",
            data: postRestrt,
        });
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
 *  @route POST /restrt/menus
 *  @desc POST Menu data (List type)
 *  @access Private
 */
const postMenu = async (req, res) => {
    const data = JSON.parse(req.body.data);
    let files = req.files;
    try {
        const postMenu = await restrtService.postMenu(files, data);
        return res.status(200).json({
            status: 200,
            success: true,
            message: "메뉴 정보 생성 성공",
            data: postMenu,
        });
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
 *  @route POST /restrt/options
 *  @desc POST options data (List type)
 *  @access Private
 */
const postOption = async (req, res) => {
    const data = req.body;
    const { id } = req.params;
    try {
        const postOption = await restrtService.postOption(id, data);
        return res.status(200).json({
            status: 200,
            success: true,
            message: "메뉴의 옵션 정보 생성 성공",
            data: postOption,
        });
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
 *  @route GET /restrt/:id
 *  @desc get restaurant data
 *  @access Private
 */
const getRestrt = async (req, res) => {
    const { id } = req.params;
    try {
        const getRestrt = await restrtService.getRestrt(id);
        return res.status(200).json({
            status: 200,
            success: true,
            message: "음식점 정보 읽기 성공",
            data: getRestrt,
        });
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
 *  @route GET /restrt
 *  @desc get restaurant list data
 *  @access Private
 */
const getRestrtList = async (req, res) => {
    try {
        const getRestrtList = await restrtService.getRestrtList();
        return res.status(200).json({
            status: 200,
            success: true,
            message: "음식점 리스트 정보 읽기 성공",
            data: getRestrtList,
        });
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
 *  @route GET /restrt/category
 *  @desc get restaurant list data by category id
 *  @access Private
 */
const getRestrtListWithCategory = async (req, res) => {
    try {
        const { c } = req.params;
        const getRestrtListWithCategory = await restrtService.getRestrtListWithCategory(c);
        return res.status(200).json({
            status: 200,
            success: true,
            message: "카테고리별 음식점 리스트 읽기 성공",
            data: getRestrtListWithCategory,
        });
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
 *  @route GET /restrt/menu
 *  @desc get menu list data
 *  @access Private
 */
const getMenuList = async (req, res) => {
    const { id } = req.params;
    try {
        const getMenuList = await restrtService.getMenuList(id);
        return res.status(200).json({
            status: 200,
            success: true,
            message: "메뉴 리스트 정보 읽기 성공",
            data: getMenuList,
        });
    }catch (error){
        console.log(error);
        res.status(400).json({
        status: 400,
        success: false,
        message: error.message,
    });
    }
};

const getMenuWithOptions = async (req, res) => {
    const { id } = req.params;
    try {
        const getMenuWithOptions = await restrtService.getMenuWithOptions(id);
        return res.status(200).json({
            status: 200,
            success: true,
            message: "메뉴 세부 정보 읽기 성공",
            data: getMenuWithOptions,
        });
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
 *  @route delete /restrt
 *  @desc DELETE restaurant data
 *  @access Private
 */
const deleteRestrt = async (req, res) => {
    const { id } = req.params;
    try {
        const deleteRestrt = await restrtService.deleteRestrt(id);
        return res.status(200).json({
            status: 200,
            success: true,
            message: "음식점 정보 삭제 성공",
            data: deleteRestrt,
        });
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
 *  @route delete /restrt/:restId/:menuId
 *  @desc DELETE menu data in restrtDB
 *  @access Private
 */
const deleteMenu = async (req, res) => {
    const { restrtId, menuId} = req.params;
    try {
        const deleteMenu = await restrtService.deleteMenu(restrtId, menuId);
        return res.status(200).json({
            status: 200,
            success: true,
            message: "메뉴 정보 삭제 성공",
            data: deleteMenu,
        });
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
 *  @route delete /restrt/:restId/:menuId
 *  @desc DELETE menu data in restrtDB
 *  @access Private
 */
const deleteOption = async (req, res) => {
    const { menuId, optionId} = req.params;
    try {
        const deleteOption = await restrtService.deleteOption(menuId, optionId);
        return res.status(200).json({
            status: 200,
            success: true,
            message: "옵션 정보 삭제 성공",
            data: deleteOption,
        });
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
 *  @route GET /restrt/search/:data
 *  @desc searching restrt data in restrtDB
 *  @access Private
 */
const searchRestrt = async (req, res) => {
    const { data } = req.params;
    try {
        const searchRestrt = await restrtService.searchRestrt(data);
        return res.status(200).json({
            status: 200,
            success: true,
            message: "식당 검색 성공",
            data: searchRestrt,
        });
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
    postRestrt,
    postMenu,
    postOption,
    getRestrt,
    getRestrtList,
    getMenuList,
    getMenuWithOptions,
    deleteRestrt,
    deleteMenu,
    deleteOption,
    searchRestrt,
    getRestrtListWithCategory,
};