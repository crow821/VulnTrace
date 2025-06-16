<?php
$host = 'mysql';
$user = 'root';
$pass = 'root';
$dbname = 'vulntarce';

$conn = new mysqli($host, $user, $pass, $dbname);

if ($conn->connect_error) {
    die("连接失败: " . $conn->connect_error);
}

$id = isset($_GET['id']) ? $_GET['id'] : '';

if (!$id) {
    echo "请在URL中使用 ?id= 参数，例如 ?id=1";
    exit;
}

// 漏洞点：未做参数过滤
$sql = "SELECT * FROM users WHERE id = $id";

echo "<p><b>执行的SQL:</b> $sql</p>";

$result = $conn->query($sql);

if ($result) {
    if ($result->num_rows > 0) {
        while($row = $result->fetch_assoc()) {
            echo "ID: {$row['id']}<br>用户名: {$row['username']}<br>邮箱: {$row['email']}<hr>";
        }
    } else {
        echo "无结果";
    }
} else {
    echo "<b>数据库错误:</b><br>" . $conn->error;
}

$conn->close();
