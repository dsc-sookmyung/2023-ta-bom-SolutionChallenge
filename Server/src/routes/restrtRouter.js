import { Router } from 'express';
import restrtController from '../controllers/restrtController.js';
import {multer} from '../middleware/image.js';

const router = Router();

router.post('/', multer.single('img'),  restrtController.postRestrt);
router.post('/menus', multer.array('img'), restrtController.postMenu);
router.post('/options/:id', restrtController.postOption);
router.get('/', restrtController.getRestrtList);
router.get('/category/:c', restrtController.getRestrtListWithCategory);
router.get('/menu-list/:id', restrtController.getMenuList);
router.get('/:id', restrtController.getRestrt);
router.get('/menu/:id', restrtController.getMenuWithOptions);
router.delete('/:id', restrtController.deleteRestrt);
router.delete('/:restrtId/:menuId', restrtController.deleteMenu);
router.delete('/menu/:menuId/:optionId', restrtController.deleteOption);
router.get('/search/:data', restrtController.searchRestrt);

export default router;
