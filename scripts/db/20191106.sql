-- Update at 20191106 as version 1.0.0
ALTER TABLE `solo`.`b3_solo_article`
ADD COLUMN `articleIsPublished` TINYINT NOT NULL DEFAULT 0 AFTER `articleStatus`;   -- add column 'articleIsPublished' in table 'article'

-- Update at 20191107 as version 1.0.0
ALTER TABLE `solo`.`b3_solo_user`
ADD COLUMN `userEmail` VARCHAR(255) NOT NULL COMMENT '用户邮箱' AFTER `userGitHubId`;   -- add column 'userEmail' in table 'user'
ALTER TABLE `solo`.`b3_solo_user`
ADD COLUMN `userPassword` VARCHAR(255) NULL COMMENT '用户密码' AFTER `userEmail`,   -- add column 'userPassword' in table 'user'
CHANGE COLUMN `userEmail` `userEmail` VARCHAR(255) NOT NULL COMMENT '用户邮箱' AFTER `userName`;

