DROP TRIGGER IF EXISTS update_discount_status_before_insert;
DROP EVENT IF EXISTS update_discount_status_event;
DROP TRIGGER IF EXISTS create_order_after_contract_signed;
-- 删除依赖于其他表的表
DROP TABLE IF EXISTS customer_follow_up;
DROP TABLE IF EXISTS role_permission;
DROP TABLE IF EXISTS order_product;
DROP TABLE IF EXISTS sales_order;
DROP TABLE IF EXISTS discount;
DROP TABLE IF EXISTS contract;

DROP TABLE IF EXISTS product;
DROP TABLE IF EXISTS template;
DROP TABLE IF EXISTS product_type;

DROP TABLE IF EXISTS parameter;
DROP TABLE IF EXISTS customer;
DROP TABLE IF EXISTS user;
DROP TABLE IF EXISTS permission;
DROP TABLE IF EXISTS role;
DROP TABLE IF EXISTS product_preview_image;
-- 身份表
CREATE TABLE role
(
    id          INT PRIMARY KEY AUTO_INCREMENT COMMENT '身份ID',
    name        VARCHAR(20) NOT NULL UNIQUE COMMENT '身份名称',
    description VARCHAR(100)
) ENGINE = InnoDB;;
INSERT INTO role (name, description)
VALUES ('董事长', '拥有所有权限的超级用户，谨慎分配'),
       ('销售经理', '分析销售数据，制定销售策略，审批合同。客户关系维护：与重要客户保持联系，确保客户满意度。'),
       ('销售专员', '直接与客户联系，推广产品或服务。管理销售合同和订单，跟踪订单状态。维护客户信息，记录客户交互历史。'),
       ('市场营销', '市场推广活动，吸引潜在客户。分析市场数据，提供优惠销售决策。'),
       ('财务人员', '根据销售订单开具销售发票，确保发票准确无误。跟踪应收账款，及时提醒客户付款，处理逾期账款'),
       ('库存管理', '确保库存充足但不过量'),
       ('人事管理', '负责人员调动'),
       ('产品管理', '产品信息维护');

-- 用户表
CREATE TABLE user
(
    id         INT PRIMARY KEY AUTO_INCREMENT COMMENT '用户ID',
    account    VARCHAR(20)                   NOT NULL UNIQUE COMMENT '账号',
    password   VARCHAR(60)                   NOT NULL COMMENT '密码',
    username   varchar(20) COMMENT '用户名',
    role       INT COMMENT '身份ID',
    branch     VARCHAR(20)                   NOT NULL COMMENT '所属分公司',
    email      VARCHAR(30) COMMENT '邮箱',
    phone      VARCHAR(15) COMMENT '手机号',
    status     ENUM ('正常', '冻结', '禁用') NOT NULL DEFAULT '正常' COMMENT '状态',
    created_at TIMESTAMP                              DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP                              DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    FOREIGN KEY (role) REFERENCES role (id) ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE = InnoDB;;
INSERT INTO user (account, password, username, role, branch)
VALUES ('111', '$2a$10$5dFMbRhhFlrTNxkgu6yJcuWCjtD08xsMaZPsQQJc.iVJXlWrtZYLq', '李董事', 1, '公司总部'),-- 初始密码均为123456
       ('211', '$2a$10$5dFMbRhhFlrTNxkgu6yJcuWCjtD08xsMaZPsQQJc.iVJXlWrtZYLq', '苗经理', 2, '吉林分公司'),
       ('311', '$2a$10$5dFMbRhhFlrTNxkgu6yJcuWCjtD08xsMaZPsQQJc.iVJXlWrtZYLq', '小韩', 3, '吉林分公司'),
       ('411', '$2a$10$5dFMbRhhFlrTNxkgu6yJcuWCjtD08xsMaZPsQQJc.iVJXlWrtZYLq', '小王', 4, '吉林分公司'),
       ('511', '$2a$10$5dFMbRhhFlrTNxkgu6yJcuWCjtD08xsMaZPsQQJc.iVJXlWrtZYLq', '小张', 5, '吉林分公司'),
       ('611', '$2a$10$5dFMbRhhFlrTNxkgu6yJcuWCjtD08xsMaZPsQQJc.iVJXlWrtZYLq', '小马', 6, '吉林分公司'),
       ('711', '$2a$10$5dFMbRhhFlrTNxkgu6yJcuWCjtD08xsMaZPsQQJc.iVJXlWrtZYLq', '小候', 7, '吉林分公司'),
       ('811', '$2a$10$5dFMbRhhFlrTNxkgu6yJcuWCjtD08xsMaZPsQQJc.iVJXlWrtZYLq', '小冬', 8, '吉林分公司');

-- 权限表
CREATE TABLE permission
(
    id          INT PRIMARY KEY AUTO_INCREMENT COMMENT '权限ID',
    name        VARCHAR(20) NOT NULL UNIQUE COMMENT '权限名称',
    description VARCHAR(50) COMMENT '权限描述',
    type        ENUM ('MENU', 'DATA', 'OPERATION') COMMENT '权限类型'
) ENGINE = InnoDB;;
INSERT INTO permission (name, description, type)
VALUES ('CONTRACT_MENU', '合同菜单', 'MENU'),
       ('ORDER_MENU', '订单菜单', 'MENU'),
       ('DISCOUNT_MENU', '优惠菜单', 'MENU'),
       ('USER_MENU', '用户菜单', 'MENU'),
       ('CUSTOMER_MENU', '客户菜单', 'MENU'),
       ('PRODUCT_MENU', '产品菜单', 'MENU'),
       ('CONFIGURATOR_MENU', '产品配置器菜单', 'MENU'), ## 7
       ('CONTRACT_OPER', '合同操作', 'OPERATION'),
       ('CONTRACT_AUDIT', '合同审核', 'OPERATION'),
       ('ORDER_OPER', '订单操作', 'OPERATION'),
       ('DISCOUNT_OPER', '优惠操作', 'OPERATION'),
       ('USER_OPER', '用户操作', 'OPERATION'),
       ('CUSTOMER_OPER', '客户操作', 'OPERATION'),
       ('PRODUCT_OPER', '产品操作', 'OPERATION'),       ## 14
       ('JILIN_BRANCH', '地区数据访问', 'DATA'),
       ('ALL_DATA_ACCESS', '全部数据访问', 'DATA');


-- 身份权限关联表
CREATE TABLE role_permission
(
    role_id       INT NOT NULL COMMENT '身份ID',
    permission_id INT NOT NULL COMMENT '权限ID',
    PRIMARY KEY (role_id, permission_id),
    FOREIGN KEY (role_id) REFERENCES role (id),
    FOREIGN KEY (permission_id) REFERENCES permission (id)
) ENGINE = InnoDB;;
INSERT INTO role_permission (role_id, permission_id)
VALUES (1, 1),  -- CONTRACT_MENU
       (1, 2),  -- ORDER_MENU
       (1, 3),  -- DISCOUNT_MENU
       (1, 4),  -- USER_MENU
       (1, 5),  -- CUSTOMER_MENU
       (1, 6),  -- PRODUCT_MENU
       (1, 7),  -- CONFIGURATOR_MENU
       (1, 8),  -- CONTRACT_OPER
       (1, 9),  -- CONTRACT_AUDIT
       (1, 10), -- ORDER_OPER
       (1, 11), -- DISCOUNT_OPER
       (1, 12), -- USER_OPER
       (1, 13), -- CUSTOMER_OPER
       (1, 14), -- PRODUCT_OPER
       (1, 15), -- JILIN_BRANCH
       (1, 16), -- ALL_DATA_ACCESS
-- 销售经理 (id=2)
       (2, 1),  -- CONTRACT_MENU
       (2, 2),  -- ORDER_MENU
       (2, 3),  -- DISCOUNT_MENU
       (2, 5),  -- CUSTOMER_MENU
       (2, 6),  -- PRODUCT_MENU
       (2, 8),  -- CONTRACT_OPER
       (2, 9),  -- CONTRACT_AUDIT
       (2, 10), -- ORDER_OPER
       (2, 11), -- DISCOUNT_OPER
       (2, 13), -- CUSTOMER_OPER
       (2, 14), -- PRODUCT_OPER
       (2, 15), -- JILIN_BRANCH
-- 销售专员 (id=3)
       (3, 1),  -- CONTRACT_MENU
       (3, 2),  -- ORDER_MENU
       (3, 5),  -- CUSTOMER_MENU
       (3, 6),  -- PRODUCT_MENU
       (3, 8),  -- CONTRACT_OPER
       (3, 10), -- ORDER_OPER
       (3, 13), -- CUSTOMER_OPER
       (3, 14), -- PRODUCT_OPER
       (3, 15), -- JILIN_BRANCH
-- 市场营销 (id=4)
       (4, 5),  -- CUSTOMER_MENU
       (4, 6),  -- PRODUCT_MENU
       (4, 13), -- CUSTOMER_OPER
       (4, 14), -- PRODUCT_OPER
       (4, 15), -- JILIN_BRANCH
-- 财务人员 (id=5)
       (5, 2),  -- ORDER_MENU
       (5, 10), -- ORDER_OPER
       (5, 15), -- JILIN_BRANCH
-- 库存管理 (id=6)
       (6, 6),  -- PRODUCT_MENU
       (6, 14), -- PRODUCT_OPER
       (6, 15), -- JILIN_BRANCH
-- 人事管理 (id=7)
       (7, 4),  -- USER_MENU
       (7, 12), -- USER_OPER
       (7, 15), -- JILIN_BRANCH
-- 产品管理 (id=8)
       (8, 6),  -- PRODUCT_MENU
       (8, 14), -- PRODUCT_OPER
       (8, 15);



-- 客户表
CREATE TABLE customer
(
    id                  INT PRIMARY KEY AUTO_INCREMENT COMMENT '客户ID',
    name                VARCHAR(50)            NOT NULL COMMENT '客户名称',
    address             VARCHAR(100) COMMENT '地址',
    contact_person      VARCHAR(20)             NOT NULL COMMENT '联系人',
    contact_phone       VARCHAR(15)             NOT NULL COMMENT '联系电话',
    contact_email       VARCHAR(30) COMMENT '邮箱',
    credit_rating       ENUM ('高', '中', '低') NOT NULL DEFAULT '中' COMMENT '信用等级',
    cooperation_history TEXT COMMENT '合作历史',
    purchase_preference TEXT COMMENT '采购偏好',
    created_at          TIMESTAMP                        DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at          TIMESTAMP                        DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) ENGINE = InnoDB;;
INSERT INTO customer (name, address, contact_person, contact_phone, contact_email, credit_rating, cooperation_history,
                      purchase_preference)
VALUES ('华晨汽车集团', '辽宁省沈阳市大东区东望街39号', '张经理', '13800138000', 'zhang@huachen.com', '高',
        '长期合作，多次采购模具', '偏好高精度模具'),
       ('一汽集团', '吉林省长春市汽车经济技术开发区东风大街2222号', '李经理', '13900139000', 'li@faw.com', '高',
        '合作过多个大型项目', '注重成本效益'),
       ('上汽集团', '上海市虹口区欧阳路58号', '王经理', '13700137000', 'wang@saic.com', '中', '偶尔合作，有潜力',
        '对新技术感兴趣'),
       ('东风汽车', '湖北省武汉市经济技术开发区东风大道88号', '赵经理', '13600136000', 'zhao@dongfeng.com', '中',
        '合作过小型项目', '偏好标准化产品'),
       ('广汽集团', '广东省广州市番禺区石楼镇科学路888号', '孙经理', '13500135000', 'sun@gac.com', '高',
        '新客户，有大额订单', '要求快速交付');

-- 客户跟进记录表
CREATE TABLE customer_follow_up
(
    id                    INT PRIMARY KEY AUTO_INCREMENT COMMENT '跟进记录ID',
    customer_id           INT                                   NOT NULL COMMENT '客户ID',
    follower_id           INT                                   NOT NULL COMMENT '跟进人ID',
    follow_up_time        TIMESTAMP                             NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '跟进时间',
    follow_up_method      ENUM ('电话', '邮件', '拜访', '其他') NOT NULL COMMENT '跟进方式',
    communication_content TEXT                                  NOT NULL COMMENT '沟通内容',
    next_plan             TEXT COMMENT '下一步计划',
    FOREIGN KEY (customer_id) REFERENCES customer (id) ON DELETE CASCADE,
    FOREIGN KEY (follower_id) REFERENCES user (id) ON DELETE CASCADE
) ENGINE = InnoDB;;
INSERT INTO customer_follow_up (customer_id, follower_id, follow_up_method, communication_content, next_plan)
VALUES (1, 3, '电话', '询问下一批次模具交付进度，客户对当前进度满意', '安排现场拜访，讨论后续合作'),
       (2, 2, '邮件', '客户提出对现有模具进行优化的需求', '准备技术方案，回复客户邮件'),
       (3, 2, '拜访', '客户对新产品感兴趣，讨论合作可能性', '安排产品演示'),
       (4, 3, '电话', '客户询问价格是否有优惠空间', '根据客户情况申请优惠'),
       (5, 3, '邮件', '新客户，询问公司产品目录和报价', '发送详细资料，安排电话会议');


-- 产品类型表
CREATE TABLE product_type
(
    id          INT PRIMARY KEY AUTO_INCREMENT COMMENT '类型ID',
    name        VARCHAR(30) NOT NULL COMMENT '类型名称',
    description TEXT COMMENT '类型描述',
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) ENGINE = InnoDB;;

INSERT INTO product_type (name, description)
VALUES ('汽车前盖模具', '用于制造汽车前盖的模具'),
       ('汽车车门模具', '用于制造汽车车门的模具'),
       ('汽车底盘模具', '用于制造汽车底盘的模具');

-- 模板表
CREATE TABLE template
(
    id              INT PRIMARY KEY AUTO_INCREMENT COMMENT '模板ID',
    product_type_id INT          NOT NULL COMMENT '关联产品类型ID',
    name            VARCHAR(50) NOT NULL COMMENT '模板名称',
    base_info       JSON COMMENT '基本信息JSON格式（如材质、用途等）',
    parameters      JSON COMMENT '参数信息JSON格式，包含名称、默认值和成本影响',
    default_cost    DECIMAL(10, 2) COMMENT '默认成本',
    pricing_formula VARCHAR(50) COMMENT '定价公式，如"cost * 1.2 + 100"',
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    FOREIGN KEY (product_type_id) REFERENCES product_type (id) ON DELETE CASCADE
) ENGINE = InnoDB;;

INSERT INTO template (product_type_id, name, base_info, parameters, default_cost, pricing_formula)
VALUES (1, '标准汽车前盖模具',
        '{
          "材质": "钢材",
          "用途": "汽车前盖"
        }',
        '[
          {
            "name": "颜色",
            "value": "红色",
            "impact_on_cost": 50
          },
          {
            "name": "尺寸",
            "value": "大号",
            "impact_on_cost": 100
          }
        ]',
        5000.00, 'cost * 1.2 + 100'),
       (2, '标准汽车车门模具',
        '{
          "材质": "铝合金",
          "用途": "汽车车门"
        }',
        '[
          {
            "name": "厚度",
            "value": "5mm",
            "impact_on_cost": 80
          },
          {
            "name": "表面处理",
            "value": "阳极氧化",
            "impact_on_cost": 120
          }
        ]',
        4000.00, 'cost * 1.15 + 50'),
       (3, '标准汽车底盘模具',
        '{
          "材质": "高强度钢",
          "用途": "汽车底盘"
        }',
        '[
          {
            "name": "硬度",
            "value": "高",
            "impact_on_cost": 60
          },
          {
            "name": "纹理",
            "value": "磨砂",
            "impact_on_cost": 30
          }
        ]',
        6000.00, 'cost * 1.1 + 20');
-- 参数表
CREATE TABLE parameter
(
    id          INT PRIMARY KEY AUTO_INCREMENT COMMENT '参数ID',
    name        VARCHAR(30) NOT NULL COMMENT '参数名称',
    description TEXT COMMENT '参数描述',
    value       JSON COMMENT '参数值列表，包含值、成本影响等信息',
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) ENGINE = InnoDB;;
INSERT INTO parameter (name, description, value)
VALUES ('颜色', '产品的外观颜色选项', '[
  {
    "value": "红色",
    "impact_on_cost": 50
  },
  {
    "value": "蓝色",
    "impact_on_cost": 50
  }
]'),
       ('尺寸', '产品的物理尺寸选项', '[
         {
           "value": "大号",
           "impact_on_cost": 100
         },
         {
           "value": "中号",
           "impact_on_cost": 75
         }
       ]'),
       ('厚度', '材料的厚度选项', '[
         {
           "value": "5mm",
           "impact_on_cost": 80
         },
         {
           "value": "3mm",
           "impact_on_cost": 60
         }
       ]'),
       ('表面处理', '材料表面处理工艺选项', '[
         {
           "value": "阳极氧化",
           "impact_on_cost": 120
         },
         {
           "value": "喷涂",
           "impact_on_cost": 90
         }
       ]'),
       ('硬度', '材料硬度选项', '[
         {
           "value": "高",
           "impact_on_cost": 60
         },
         {
           "value": "中",
           "impact_on_cost": 40
         }
       ]'),
       ('纹理', '产品表面纹理选项', '[
         {
           "value": "磨砂",
           "impact_on_cost": 30
         },
         {
           "value": "光滑",
           "impact_on_cost": 20
         }
       ]');

-- 产品图片预览表
CREATE TABLE product_preview_image
(
    id                INT PRIMARY KEY AUTO_INCREMENT COMMENT '图片ID',
    base_image_url    VARCHAR(200) NOT NULL COMMENT '基础图片URL',
    parameter_name    VARCHAR(30) NOT NULL COMMENT '参数名称',
    parameter_value   VARCHAR(30) NOT NULL COMMENT '参数值',
    overlay_image_url VARCHAR(200) COMMENT '叠加图片URL（可选）',
    created_at        TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at        TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    UNIQUE KEY (parameter_name, parameter_value)
) ENGINE = InnoDB;;

INSERT INTO product_preview_image (base_image_url, parameter_name, parameter_value, overlay_image_url)
VALUES ('https://example.com/base-mold.jpg', '颜色', '红色', 'https://example.com/color-red-overlay.png'),
       ('https://example.com/base-mold.jpg', '颜色', '蓝色', 'https://example.com/color-blue-overlay.png'),
       ('https://example.com/base-mold.jpg', '尺寸', '大号', 'https://example.com/size-large-overlay.png'),
       ('https://example.com/base-mold.jpg', '尺寸', '中号', 'https://example.com/size-medium-overlay.png'),
       ('https://example.com/base-mold.jpg', '表面处理', '阳极氧化',
        'https://example.com/surface-anodized-overlay.png'),
       ('https://example.com/base-mold.jpg', '表面处理', '喷涂', 'https://example.com/surface-spray-overlay.png');


-- 产品表（存储最终生成的汽车模具产品）
CREATE TABLE product
(
    id              INT PRIMARY KEY AUTO_INCREMENT COMMENT '产品ID',
    template_id     INT COMMENT '关联模板ID，可为空表示无模板',
    product_type_id INT          NOT NULL COMMENT '关联产品类型ID',
    name            VARCHAR(50) NOT NULL COMMENT '产品名称',
    base_info       TEXT COMMENT '基本信息JSON格式',
    parameters      TEXT COMMENT '参数信息JSON格式',
    main_image_url  VARCHAR(200) COMMENT '主图URL',
    cost            DECIMAL(10, 2) COMMENT '成本',
    price           DECIMAL(10, 2) COMMENT '价格',
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    FOREIGN KEY (template_id) REFERENCES template (id) ON DELETE SET NULL,
    FOREIGN KEY (product_type_id) REFERENCES product_type (id) ON DELETE CASCADE
) ENGINE = InnoDB;;

INSERT INTO product (template_id, product_type_id, name, base_info, parameters, main_image_url, cost, price)
VALUES (1, 1, '红色大号汽车前盖模具', '{"材质":"钢材","用途":"汽车前盖","颜色":"红色","尺寸":"大号"}',
        '[{"name":"颜色","value":"红色","impact_on_cost":50},{"name":"尺寸","value":"大号","impact_on_cost":100}]',
        'https://example.com/red-large-mold.jpg', 500.00, 600.00),
       (2, 2, '加厚汽车车门模具', '{"材质":"铝合金","用途":"汽车车门","厚度":"5mm","表面处理":"阳极氧化"}',
        '[{"name":"厚度","value":"5mm","impact_on_cost":80},{"name":"表面处理","value":"阳极氧化","impact_on_cost":120}]',
        'https://example.com/thick-door-mold.jpg', 400.00, 800.00),
       (NULL, 3, '自定义汽车底盘模具', '{"材质":"高强度钢","用途":"汽车底盘","硬度":"高","纹理":"磨砂"}',
        '[{"name":"硬度","value":"高","impact_on_cost":60},{"name":"纹理","value":"磨砂","impact_on_cost":30}]',
        'https://example.com/custom-chassis-mold.jpg', 6090.00, 6758.00);


-- 合同表
CREATE TABLE contract
(
    id                       INT PRIMARY KEY AUTO_INCREMENT COMMENT '合同ID',
    customer_id              INT            NOT NULL COMMENT '客户ID',
    user_id                  INT            NOT NULL COMMENT '创建人ID',
    order_info               JSON           NOT NULL COMMENT '订单信息（包括产品详情、优惠信息等）',
    total_original_price     DECIMAL(10, 2) NOT NULL COMMENT '总原价',
    total_final_price        DECIMAL(10, 2) NOT NULL COMMENT '总最终价',
    full_reduction_amount    DECIMAL(10, 2) COMMENT '满减金额',
    full_reduction_threshold DECIMAL(10, 2) COMMENT '满减门槛',
    status                   ENUM ('草稿', '已签订', '终止') DEFAULT '草稿',
    created_at               TIMESTAMP                       DEFAULT CURRENT_TIMESTAMP,
    updated_at               TIMESTAMP                       DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES customer (id),
    FOREIGN KEY (user_id) REFERENCES user (id)
) ENGINE = InnoDB;
INSERT INTO contract (customer_id, user_id, order_info, total_original_price, total_final_price, full_reduction_amount,
                      full_reduction_threshold)
VALUES (1, 1,
        '{
          "products": [
            {
              "product_id": 1,
              "quantity": 10,
              "original_price": 6000.00,
              "final_price": 5400.00,
              "discount_strength": 0.9
            },
            {
              "product_id": 2,
              "quantity": 5,
              "original_price": 4000.00,
              "final_price": 4000.00,
              "discount_strength": 0
            }
          ]
        }', 9400.00, 9000.00, 400.00, 6000.00);

-- 订单表
CREATE TABLE sales_order
(
    id                       INT PRIMARY KEY AUTO_INCREMENT COMMENT '订单ID',
    contract_id              INT            NOT NULL UNIQUE COMMENT '合同ID',
    full_reduction_amount    DECIMAL(10, 2) COMMENT '满减金额',
    full_reduction_threshold DECIMAL(10, 2) COMMENT '满减门槛',
    total_original_price     DECIMAL(10, 2) NOT NULL COMMENT '总原价',
    total_final_price        DECIMAL(10, 2) NOT NULL COMMENT '总最终价',
    status                   ENUM ('待生产', '生产中', '已交付') DEFAULT '待生产',
    created_at               TIMESTAMP                           DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (contract_id) REFERENCES contract (id)
) ENGINE = InnoDB;

-- 订单与产品关联表
CREATE TABLE order_product
(
    order_id          INT            NOT NULL COMMENT '订单ID',
    product_id        INT            NOT NULL COMMENT '产品ID',
    quantity          INT            NOT NULL COMMENT '产品数量',
    original_price    DECIMAL(10, 2) NOT NULL COMMENT '原价',
    final_price       DECIMAL(10, 2) NOT NULL COMMENT '最终价',
    discount_strength DECIMAL(10, 2) COMMENT '优惠力度',
    PRIMARY KEY (order_id, product_id),
    FOREIGN KEY (order_id) REFERENCES sales_order (id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES product (id) ON DELETE CASCADE
) ENGINE = InnoDB;

-- 优惠表
CREATE TABLE discount
(
    id                INT PRIMARY KEY AUTO_INCREMENT COMMENT '优惠ID',
    discount_type     ENUM ('打折', '满减') NOT NULL COMMENT '优惠类型',
    product_id        INT COMMENT '产品ID，用于产品打折',
    discount_strength DECIMAL(10, 2) COMMENT '打折力度',
    min_amount        DECIMAL(10, 2) COMMENT '最低消费金额（订单满减时使用）',
    start_date        DATE                  NOT NULL COMMENT '生效日期',
    end_date          DATE                  NOT NULL COMMENT '截至日期',
    status            ENUM ('未开始', '生效', '失效') DEFAULT '未开始' COMMENT '优惠状态',
    created_at        TIMESTAMP                       DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at        TIMESTAMP                       DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    FOREIGN KEY (product_id) REFERENCES product (id)
) ENGINE = InnoDB COMMENT ='优惠申请表';

-- 触发器
DELIMITER $$
CREATE TRIGGER update_discount_status_before_insert
    BEFORE INSERT
    ON discount
    FOR EACH ROW
BEGIN
    -- 根据开始和截止日期设置初始状态
    IF NEW.start_date > CURDATE() THEN
        SET NEW.status = '未开始';
    ELSEIF NEW.end_date < CURDATE() THEN
        SET NEW.status = '失效';
    ELSE
        SET NEW.status = '生效';
    END IF;
END$$

DELIMITER ;

-- 事件：每天自动更新优惠状态
DELIMITER $$
CREATE EVENT update_discount_status_event
    ON SCHEDULE
        EVERY 1 DAY
            STARTS CURRENT_TIMESTAMP
    DO
    BEGIN
        -- 更新未开始的优惠状态为生效
        UPDATE discount
        SET status = '生效'
        WHERE status = '未开始'
          AND start_date <= CURDATE()
          AND end_date >= CURDATE();

        -- 更新已生效的优惠状态为失效
        UPDATE discount
        SET status = '失效'
        WHERE status = '生效'
          AND end_date < CURDATE();
    END$$
DELIMITER ;

INSERT INTO discount (discount_type, product_id, discount_strength, min_amount, start_date, end_date)
VALUES ('打折', 1, 0.9, NULL, '2025-03-01', '2025-07-02'),
       ('满减', NULL, 400.00, 6000.00, '2025-03-01', '2025-06-01');

DELIMITER $$
CREATE TRIGGER create_order_after_contract_signed
    AFTER UPDATE
    ON contract
    FOR EACH ROW
BEGIN
    IF NEW.status = '已签订' AND OLD.status != '已签订' THEN
        -- 创建订单
        INSERT INTO sales_order (contract_id, total_original_price, total_final_price, full_reduction_amount,
                                 full_reduction_threshold)
        VALUES (NEW.id, NEW.total_original_price, NEW.total_final_price, NEW.full_reduction_amount,
                NEW.full_reduction_threshold);

        -- 获取刚创建的订单ID
        SET @last_order_id = LAST_INSERT_ID();

        -- 解析JSON数据并插入订单与产品关联数据
        SET @products_json = NEW.order_info;
        SET @i = 0;
        WHILE @i < JSON_LENGTH(@products_json, '$.products')
            DO
                SET @product_id = JSON_EXTRACT(@products_json, CONCAT('$.products[', @i, '].product_id'));
                SET @quantity = JSON_EXTRACT(@products_json, CONCAT('$.products[', @i, '].quantity'));
                SET @original_price = JSON_EXTRACT(@products_json, CONCAT('$.products[', @i, '].original_price'));
                SET @final_price = JSON_EXTRACT(@products_json, CONCAT('$.products[', @i, '].final_price'));
                SET @discount_type = JSON_EXTRACT(@products_json, CONCAT('$.products[', @i, '].discount_type'));
                SET @discount_strength = JSON_EXTRACT(@products_json, CONCAT('$.products[', @i, '].discount_strength'));

                INSERT INTO order_product (order_id, product_id, quantity, original_price, final_price,
                                           discount_strength)
                VALUES (@last_order_id, @product_id, @quantity, @original_price, @final_price, @discount_strength);

                SET @i = @i + 1;
            END WHILE;
    END IF;
END$$
DELIMITER ;
-- 更新合同状态以触发订单创建
UPDATE contract
SET status = '已签订'
WHERE id = 1;