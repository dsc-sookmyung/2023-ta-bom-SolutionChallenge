import { Router } from 'express';
import userController from '../controllers/userController.js';
import {multer} from '../middleware/image.js'

const router = Router();

router.put('/:uid', multer.single('photoURL'), userController.updateUser);
router.get('/:uid', userController.getUser);
router.post('/loc/:uid', userController.postUserLocation);
router.get('/loc/:uid', userController.getUserLocation);

export default router;