-- Update at 20191106 as version 1.0.0
ALTER TABLE `solo`.`b3_solo_article`
ADD COLUMN `articleIsPublished` TINYINT NOT NULL DEFAULT 0 AFTER `articleStatus`;   -- add column 'articleIsPublished' in table 'article'

-- Update at 20191107 as version 1.0.0
ALTER TABLE `solo`.`b3_solo_user`
ADD COLUMN `userEmail` VARCHAR(255) NOT NULL COMMENT '用户邮箱' AFTER `userGitHubId`;   -- add column 'userEmail' in table 'user'
ALTER TABLE `solo`.`b3_solo_user`
ADD COLUMN `userPassword` VARCHAR(255) NULL COMMENT '用户密码' AFTER `userEmail`,   -- add column 'userPassword' in table 'user'
CHANGE COLUMN `userEmail` `userEmail` VARCHAR(255) NOT NULL COMMENT '用户邮箱' AFTER `userName`;

-- Update at 20191109 as version copied from 3.6.6
ALTER TABLE `solo`.`b3_solo_tag`
CHANGE COLUMN `tagPublishedRefCount` `tagPublishedRefCount` INT(11) NULL COMMENT '标签关联的已发布文章计数' ,
CHANGE COLUMN `tagReferenceCount` `tagReferenceCount` INT(11) NULL COMMENT '标签关联的文章计数' ;
ALTER TABLE `solo`.`b3_solo_archivedate`
CHANGE COLUMN `archiveDateArticleCount` `archiveDateArticleCount` INT(11) NULL COMMENT '存档日期文章计数，即某个月的文章总数' ,
CHANGE COLUMN `archiveDatePublishedArticleCount` `archiveDatePublishedArticleCount` INT(11) NULL COMMENT '存档日期已发布的文章计数，即某个月的已发布文章总数' ;
