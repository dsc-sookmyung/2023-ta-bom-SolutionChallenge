import { Router } from 'express';
import reviewController from '../controllers/reviewController.js';
import {multer} from '../middleware/image.js';

const router = Router();

router.post('', multer.single('img'), reviewController.postReview);
router.get('/restrt/:id', reviewController.getReviewListByRestrtIdWithPage); //?page=2&size=3
router.get('/user/:id', reviewController.getReviewListByUserIdWithPage); //?page=2&size=3
router.delete('/:id', reviewController.deleteReview);

export default router;