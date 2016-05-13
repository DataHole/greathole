CREATE TABLE `hole_job` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '任务ID',
  `name` varchar(100) NOT NULL COMMENT '任务名称',
  `description` varchar(300) DEFAULT '' COMMENT '任务描述',
  `crontab` varchar(200) NOT NULL DEFAULT '' COMMENT '任务执行时间,定时任务填写,依赖任务不用填写',
  `command` varchar(500) NOT NULL COMMENT '任务启动命令,hadoop ,hive ,shell',
  `alarm_lazy_minute` int(10) NOT NULL DEFAULT '0' COMMENT '任务启动失败后触发报警的时间 0:立即报警 n:任务重试n分钟后报警',
  `alarm_email` varchar(500) DEFAULT NULL COMMENT '依赖报警邮件列表，逗号间隔',
  `alarm_phone` varchar(300) DEFAULT NULL COMMENT '依赖报警手机号列表，逗号间隔',
  `enable` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否启用 0:未启用 1:启用',
  `auto_retry` tinyint(1) NOT NULL DEFAULT '0' COMMENT '执行失败后是否自动重试 0:不自动重试 1:执行失败后自动重试,最多重试三次',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `params` varchar(1000) NOT NULL DEFAULT '' COMMENT '传递给命令的额外参数',
  `task_type` varchar(10) NOT NULL DEFAULT 'hadoop,shell...',
  `owner` varchar(200) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unq_name` (`name`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='任务元信息' ;

CREATE TABLE `hole_depend` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `job_id` bigint(20) NOT NULL COMMENT '任务ID',
  `depend_job_id` bigint(20) NOT NULL COMMENT '依赖任务ID',
  `description` varchar(300) DEFAULT NULL COMMENT '依赖描述',
  `depend_date_format` varchar(15) NOT NULL DEFAULT 'days ago'  COMMENT '依赖日期计算纬度 minutes,hours,days,months,weeks,years [ago]',
  `depend_values` varchar(240) NOT NULL DEFAULT '0' COMMENT '多个依赖值用逗号分割 如:depend_field=hours ago时 1,2表示当前任务前1小时及前2小时的任务实例已执行成功',
  `match_minute` tinyint(1) NOT NULL DEFAULT 0 COMMENT '分 依赖匹配 0:不匹配 1:匹配',
  `match_hour` tinyint(1) NOT NULL DEFAULT 0 COMMENT '时 依赖匹配 0:不匹配 1:匹配',
  `match_day` tinyint(1) NOT NULL DEFAULT 1 COMMENT '日 依赖匹配 0:不匹配 1:匹配',
  `match_month` tinyint(1) NOT NULL DEFAULT 1 COMMENT '月 依赖匹配 0:不匹配 1:匹配',
  `match_year` tinyint(1) NOT NULL DEFAULT 1 COMMENT '年 依赖匹配 0:不匹配 1:匹配',
  `enable` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否启用 0:未启用 1:启用',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_meta` (`meta_id`) USING BTREE
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COMMENT='任务依赖配置';

CREATE TABLE `hole_instance_run` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '自增id,taskid',
  `job_id` bigint(20) NOT NULL COMMENT 'jobID',
  `minute` char(2) NOT NULL COMMENT '分',
  `hour` char(2) NOT NULL COMMENT '时',
  `day` char(2) NOT NULL COMMENT '日',
  `month` char(2) NOT NULL COMMENT '月',
  `year` char(4) NOT NULL COMMENT '年',
  `pid` int(11) NOT NULL COMMENT '0:依赖未满足，待重试 !0:正在执行的进程PID',
  `alarmed` tinyint(1) NOT NULL COMMENT '是否已触发报警 0:尚未报警 1:已报警',
  `exec_count` INT NOT NULL DEFAULT 1 COMMENT '执行次数,用户自动重试限制次数',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unq_idx` (`meta_id`,`minute`,`hour`,`day`,`month`,`year`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='执行中的任务实例';

CREATE TABLE `hole_instance_done` (
  `id` bigint(20) NOT NULL COMMENT 'task_id,hole_instance_done中id',
  `meta_id` bigint(20) NOT NULL COMMENT 'jobID',
  `minute` char(2) NOT NULL COMMENT '分',
  `hour` char(2) NOT NULL COMMENT '时',
  `day` char(2) NOT NULL COMMENT '日',
  `month` char(2) NOT NULL COMMENT '月',
  `year` char(4) NOT NULL COMMENT '年',
  `stat` bigint(20) NOT NULL COMMENT '0:成功 -1:失败 >0:依赖任务失败(任务实例ID)',
  `exec_count` INT NOT NULL DEFAULT 1 COMMENT '执行次数,用户自动重试限制次数',
  `start_time` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '任务开始时间',
  `start_time_real` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '任务实际开始时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间,也是任务的结束时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unq_idx` (`meta_id`,`minute`,`hour`,`day`,`month`,`year`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='已完成的任务实例';

create table `hole_job_info`(
  `id` BIGINT(20) PRIMARY KEY NOT NULL COMMENT 'id',
  `job_id` BIGINT(20) NOT NULL COMMENT '任务id',
  `file_name` BIGINT(20) NOT NULL COMMENT 'job 文件名'
)ENGINE =MyISAM DEFAULT CHARSET=utf8 COMMENT 'job运行时的所依赖的文件';




