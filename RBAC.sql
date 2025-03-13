DROP TABLE IF EXISTS role_permission;
DROP TABLE IF EXISTS user;
DROP TABLE IF EXISTS permission;
DROP TABLE IF EXISTS role;

-- 角色表
CREATE TABLE role (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(50) NOT NULL UNIQUE,
  description VARCHAR(255)
);
INSERT INTO role (name, description) VALUES
('CEO','CEO'),
('GENERAL_MANAGER', '总经理'),
('SALES_DIRECTOR', '销售总监'),
('REGION_MANAGER', '地区经理'),
('SALES_SPECIALIST', '销售专员');


-- 用户表
CREATE TABLE user (
  id INT PRIMARY KEY AUTO_INCREMENT,
  account VARCHAR(50) NOT NULL UNIQUE,
  password VARCHAR(100) NOT NULL,
  username varchar(50),
  role int,
  email VARCHAR(100),
  phone VARCHAR(20),
  status ENUM('正常', '冻结', '禁用') NOT NULL DEFAULT '正常',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (role) REFERENCES role(id) ON UPDATE CASCADE ON DELETE SET NULL
);

-- 1 'CEO' 2 '总经理' 3 '销售总监' 4'地区经理' 5 '销售专员'
INSERT INTO user (account, password, username, role) VALUES
('147', '$2a$10$5dFMbRhhFlrTNxkgu6yJcuWCjtD08xsMaZPsQQJc.iVJXlWrtZYLq', '李总', 1),-- 初始密码均为123456
('139', '$2a$10$5dFMbRhhFlrTNxkgu6yJcuWCjtD08xsMaZPsQQJc.iVJXlWrtZYLq', '李经理', 2),
('362', '$2a$10$5dFMbRhhFlrTNxkgu6yJcuWCjtD08xsMaZPsQQJc.iVJXlWrtZYLq', '李总监', 3),
('100', '$2a$10$5dFMbRhhFlrTNxkgu6yJcuWCjtD08xsMaZPsQQJc.iVJXlWrtZYLq', '王经理', 4),
('311', '$2a$10$5dFMbRhhFlrTNxkgu6yJcuWCjtD08xsMaZPsQQJc.iVJXlWrtZYLq', '小张', 5);

-- 权限表
CREATE TABLE permission (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(50) NOT NULL UNIQUE,
  description VARCHAR(255),
  type VARCHAR(20) CHECK (type IN ('MENU', 'DATA', 'OPERATION')) -- 权限类型
);
INSERT INTO permission (name, description, type) VALUES
('DASHBOARD_VIEW', '查看仪表盘', 'MENU'),
('REPORTS_VIEW', '查看报表', 'MENU'),
('USER_MANAGEMENT', '用户管理', 'MENU'),
('DATA_EXPORT', '数据导出', 'OPERATION'),
('REGION_DATA_ACCESS', '地区数据访问', 'DATA'),
('ALL_DATA_ACCESS', '全部数据访问', 'DATA');


-- 角色权限关联表
CREATE TABLE role_permission (
  role_id INT NOT NULL,
  permission_id INT NOT NULL,
  PRIMARY KEY (role_id, permission_id),
  FOREIGN KEY (role_id) REFERENCES role(id),
  FOREIGN KEY (permission_id) REFERENCES permission(id)
);
-- 1 'CEO' 2 '总经理' 3 '销售总监' 4'地区经理' 5 '销售专员'
--
INSERT INTO role_permission (role_id, permission_id) VALUES
(1, 1), (1, 2), (1, 3), (1, 4), (1, 5), (1, 6),
(2, 1), (2, 2), (2, 3), (2, 4), (2, 5), (2, 6),
(3, 1), (3, 2), (3, 4), (3, 5), 
(4, 1), (4, 2), (4, 4), (4, 5), 
(5, 1), (5, 5);
