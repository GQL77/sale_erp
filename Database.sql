DROP TABLE IF EXISTS role_permission;
DROP TABLE IF EXISTS user;
DROP TABLE IF EXISTS permission;
DROP TABLE IF EXISTS role;

-- 身份表
CREATE TABLE role (
  id INT PRIMARY KEY AUTO_INCREMENT COMMENT '身份ID',
  name VARCHAR(50) NOT NULL UNIQUE COMMENT '身份名称',
  description VARCHAR(255)
);
INSERT INTO role (name, description) VALUES
('董事长', '拥有所有权限的超级用户，谨慎分配'),
('销售经理', '分析销售数据，制定销售策略，审批优惠申请。客户关系维护：与重要客户保持联系，确保客户满意度。'),
('销售专员', '直接与客户联系，推广产品或服务。管理销售合同和订单，跟踪订单状态。维护客户信息，记录客户交互历史。'),
('市场营销', '市场推广活动，吸引潜在客户。分析市场数据，提供市销售决策。'),
('财务人员', '根据销售订单开具销售发票，确保发票准确无误。跟踪应收账款，及时提醒客户付款，处理逾期账款'),
('库存管理', '确保库存充足但不过量'),
('人事管理', '负责人员调动'),
('产品管理', '产品信息维护');

-- 用户表
CREATE TABLE user (
  id INT PRIMARY KEY AUTO_INCREMENT COMMENT '用户ID',
  account VARCHAR(50) NOT NULL UNIQUE COMMENT '账号',
  password VARCHAR(100) NOT NULL COMMENT '密码',
  username varchar(50) COMMENT '用户名',
  role INT COMMENT '身份ID',
  branch VARCHAR(50) NOT NULL COMMENT '所属分公司',
  email VARCHAR(100) COMMENT '邮箱',
  phone VARCHAR(20) COMMENT '手机号',
  status ENUM('正常', '冻结', '禁用') NOT NULL DEFAULT '正常' COMMENT '状态',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  FOREIGN KEY (role) REFERENCES role(id) ON UPDATE CASCADE ON DELETE SET NULL
);
INSERT INTO user (account, password, username, role, branch) VALUES
('111', '$2a$10$5dFMbRhhFlrTNxkgu6yJcuWCjtD08xsMaZPsQQJc.iVJXlWrtZYLq', '李董事', 1, '公司总部'),-- 初始密码均为123456
('211', '$2a$10$5dFMbRhhFlrTNxkgu6yJcuWCjtD08xsMaZPsQQJc.iVJXlWrtZYLq', '苗经理', 2, '吉林分公司'),
('311', '$2a$10$5dFMbRhhFlrTNxkgu6yJcuWCjtD08xsMaZPsQQJc.iVJXlWrtZYLq', '小韩', 3, '吉林分公司'),
('411', '$2a$10$5dFMbRhhFlrTNxkgu6yJcuWCjtD08xsMaZPsQQJc.iVJXlWrtZYLq', '小王', 4, '吉林分公司'),
('511', '$2a$10$5dFMbRhhFlrTNxkgu6yJcuWCjtD08xsMaZPsQQJc.iVJXlWrtZYLq', '小张', 5, '吉林分公司'),
('611', '$2a$10$5dFMbRhhFlrTNxkgu6yJcuWCjtD08xsMaZPsQQJc.iVJXlWrtZYLq', '小马', 6, '吉林分公司'),
('711', '$2a$10$5dFMbRhhFlrTNxkgu6yJcuWCjtD08xsMaZPsQQJc.iVJXlWrtZYLq', '小候', 7, '吉林分公司'),
('811', '$2a$10$5dFMbRhhFlrTNxkgu6yJcuWCjtD08xsMaZPsQQJc.iVJXlWrtZYLq', '小冬', 8, '吉林分公司');

-- 权限表
CREATE TABLE permission (
  id INT PRIMARY KEY AUTO_INCREMENT COMMENT '权限ID',
  name VARCHAR(50) NOT NULL UNIQUE COMMENT '权限名称',
  description VARCHAR(255) COMMENT '权限描述',
  type VARCHAR(20) CHECK (type IN ('MENU', 'DATA', 'OPERATION')) COMMENT '权限类型'
);
INSERT INTO permission (name, description, type) VALUES
('DASHBOARD_VIEW', '查看仪表盘', 'MENU'),
('REPORTS_VIEW', '查看报表', 'MENU'),
('USER_MANAGEMENT', '用户管理', 'MENU'),
('PRODUCT_MANAGEMENT', '产品管理', 'MENU'),
('CUSTOMER_MANAGEMENT', '客户管理', 'MENU'),
('DATA_EXPORT', '数据导出', 'OPERATION'),
('REGION_DATA_ACCESS', '地区数据访问', 'DATA'),
('ALL_DATA_ACCESS', '全部数据访问', 'DATA');



-- 身份权限关联表
CREATE TABLE role_permission (
  role_id INT NOT NULL COMMENT '身份ID',
  permission_id INT NOT NULL COMMENT '权限ID',
  PRIMARY KEY (role_id, permission_id),
  FOREIGN KEY (role_id) REFERENCES role(id),
  FOREIGN KEY (permission_id) REFERENCES permission(id)
);
INSERT INTO role_permission (role_id, permission_id) VALUES
(1, 1), (1, 2), (1, 3), (1, 4), (1, 5), (1, 6),
(2, 1), (2, 2), (2, 3), (2, 4), (2, 5), (2, 6),
(3, 1), (3, 2), (3, 4), (3, 5), 
(4, 1), (4, 2), (4, 4), (4, 5), 
(5, 1), (5, 5);

-- 客户信息表
CREATE TABLE customer (
  id INT PRIMARY KEY AUTO_INCREMENT COMMENT '客户ID',
  name VARCHAR(100) NOT NULL COMMENT '客户名称',
  address VARCHAR(255) COMMENT '地址',
  contact_person VARCHAR(50) NOT NULL COMMENT '联系人',
  contact_phone VARCHAR(20) NOT NULL COMMENT '联系电话',
  contact_email VARCHAR(100) COMMENT '邮箱',
  credit_rating ENUM('高', '中', '低') NOT NULL DEFAULT '中' COMMENT '信用等级',
  cooperation_history TEXT COMMENT '合作历史',
  purchase_preference TEXT COMMENT '采购偏好',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
);
INSERT INTO customer (name, address, contact_person, contact_phone, contact_email, credit_rating, cooperation_history, purchase_preference) VALUES
('华晨汽车集团', '辽宁省沈阳市大东区东望街39号', '张经理', '13800138000', 'zhang@huachen.com', '高', '长期合作，多次采购模具', '偏好高精度模具'),
('一汽集团', '吉林省长春市汽车经济技术开发区东风大街2222号', '李经理', '13900139000', 'li@faw.com', '高', '合作过多个大型项目', '注重成本效益'),
('上汽集团', '上海市虹口区欧阳路58号', '王经理', '13700137000', 'wang@saic.com', '中', '偶尔合作，有潜力', '对新技术感兴趣'),
('东风汽车', '湖北省武汉市经济技术开发区东风大道88号', '赵经理', '13600136000', 'zhao@dongfeng.com', '中', '合作过小型项目', '偏好标准化产品'),
('广汽集团', '广东省广州市番禺区石楼镇科学路888号', '孙经理', '13500135000', 'sun@gac.com', '高', '新客户，有大额订单', '要求快速交付');

-- 客户跟进记录表
CREATE TABLE customer_follow_up (
  id INT PRIMARY KEY AUTO_INCREMENT COMMENT '跟进记录ID',
  customer_id INT NOT NULL COMMENT '客户ID',
  follower_id INT NOT NULL COMMENT '跟进人ID',
  follow_up_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '跟进时间',
  follow_up_method ENUM('电话', '邮件', '拜访', '其他') NOT NULL COMMENT '跟进方式',
  communication_content TEXT NOT NULL COMMENT '沟通内容',
  next_plan TEXT COMMENT '下一步计划',
  FOREIGN KEY (customer_id) REFERENCES customer(id) ON DELETE CASCADE,
  FOREIGN KEY (follower_id) REFERENCES user(id) ON DELETE CASCADE
);
INSERT INTO customer_follow_up (customer_id, follower_id, follow_up_method, communication_content, next_plan) VALUES
(1, 3, '电话', '询问下一批次模具交付进度，客户对当前进度满意', '安排现场拜访，讨论后续合作'),
(2, 2, '邮件', '客户提出对现有模具进行优化的需求', '准备技术方案，回复客户邮件'),
(3, 2, '拜访', '客户对新产品感兴趣，讨论合作可能性', '安排产品演示'),
(4, 3, '电话', '客户询问价格是否有优惠空间', '根据客户情况申请优惠'),
(5, 3, '邮件', '新客户，询问公司产品目录和报价', '发送详细资料，安排电话会议');



-- 产品表（假设已存在）
CREATE TABLE product (
  id INT PRIMARY KEY AUTO_INCREMENT COMMENT '产品ID',
  name VARCHAR(100) NOT NULL COMMENT '产品名称',
  type ENUM('冲压模具', '注塑模具', '') NOT NULL COMMENT '产品类型',
  model VARCHAR(50) COMMENT '型号',
  specification TEXT COMMENT '规格',
  material VARCHAR(50) COMMENT '材质',
  process TEXT COMMENT '工艺',
  cost DECIMAL(10, 2) NOT NULL COMMENT '成本',
  sale_price DECIMAL(10, 2) NOT NULL COMMENT '售价',
  image_url VARCHAR(255) COMMENT '产品图片URL',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
);

-- 产品表 (product)
INSERT INTO product (name, model, specification, material, process, cost, sale_price, image_url) VALUES
('汽车覆盖件模具', 'FM-001', '尺寸：3000mm×1500mm×500mm', 'SKD61', '数控加工', 50000.00, 80000.00, 'http://example.com/product1.jpg'),
('汽车内饰模具', 'FM-002', '尺寸：1000mm×800mm×300mm', 'P20', '精密加工', 20000.00, 35000.00, 'http://example.com/product2.jpg'),
('汽车灯具模具', 'FM-003', '尺寸：500mm×400mm×200mm', 'H13', '高速加工', 15000.00, 28000.00, 'http://example.com/product3.jpg'),
('汽车发动机模具', 'FM-004', '尺寸：2000mm×1000mm×600mm', 'ASM23', '特种加工', 70000.00, 100000.00, 'http://example.com/product4.jpg'),
('汽车底盘模具', 'FM-005', '尺寸：2500mm×1200mm×400mm', 'DC53', '复合加工', 60000.00, 90000.00, 'http://example.com/product5.jpg');

-- 优惠申请表
CREATE TABLE discount_permission (
  id INT PRIMARY KEY AUTO_INCREMENT COMMENT '优惠权限ID',
  applicants_id INT NOT NULL COMMENT '申请人ID',
  approver_id INT NOT NULL COMMENT '审批人ID',
  customer_id INT NOT NULL COMMENT '客户ID',
  product_id INT NOT NULL COMMENT '产品ID',
  original_amount DECIMAL(10, 2) NOT NULL COMMENT '原金额',
  final_amount DECIMAL(10, 2) NOT NULL COMMENT '最终金额',
  discount_strength DECIMAL(10, 2) NOT NULL COMMENT '优惠力度',
  discount_type ENUM('打折', '满减', '其他') NOT NULL COMMENT '优惠方式',
  discount_reason TEXT NOT NULL COMMENT '优惠原因',
  application_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '申请时间',
  approval_status ENUM('待审批', '已通过', '未通过') NOT NULL DEFAULT '待审批' COMMENT '审批状态',
  approval_time TIMESTAMP COMMENT '审批时间',
  approval_opinion TEXT COMMENT '审批意见',
  FOREIGN KEY (applicants_id) REFERENCES user(id),
  FOREIGN KEY (customer_id) REFERENCES customer(id) ON DELETE CASCADE,
  FOREIGN KEY (product_id) REFERENCES product(id) ON DELETE CASCADE,
  FOREIGN KEY (approver_id) REFERENCES user(id) ON DELETE SET NULL
);
INSERT INTO discount_permission (applicants_id,approver_id,customer_id, product_id, original_amount, final_amount, discount_strength, discount_type, discount_reason) VALUES
(3, 2, 1, 1, 6000.00, 5500.00, 500.00, '满减', '老客户，批量采购，满6000减500'),
(3, 1, 2, 2, 300000.00, 270000.00, 0.90, '打折', '大额订单，打9折，促进合作'),
(3, 2, 3, 3, 2000.00, 1900.00, 100.00, '满减', '新客户开发，吸引合作，满2000减100'),
(3, 2, 4, 4, 10000.00, 9500.00, 0.95, '打折', '清理库存产品，打95折'),
(3, 2, 5, 5, 2500.00, 2450.00, 50, '其他', '市场竞争激烈,降价销售');

