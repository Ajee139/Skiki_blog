<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
header("Content-Type: application/json; charset=UTF-8");

// Handle preflight OPTIONS request
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

// Database connection
$db = mysqli_connect("localhost", "root", "", "flutter_blog_skiki");
if (!$db) {
    echo json_encode(["error" => "Database connection failed: " . mysqli_connect_error()]);
    exit();
}

// Check if the request method is POST
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Retrieve the POST data
    $title = $_POST['title'] ?? null;
    $body = $_POST['body'] ?? null;
    $category_name = $_POST['category_name'] ?? null; // Use standardized date format for storage
$create_date = date(format: 'd/y/m');
 
$author = $_POST['author'];
    $image = $_FILES['image']['name'];
    $imagePath = "uploads/.$image";

    $tmp_name = $_FILES['image']['tmp_name'];
    move_uploaded_file($tmp_name, $imagePath);

    $db->query("INSERT INTO post_table(image, author, post_date, title, body, category_name) VALUES ($image, $author, $create_date, $title, $body, $category_name)");
}

$db->close();
?>
