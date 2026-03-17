<!DOCTYPE html>
<html>
<head>
    <title>Login Page</title>
</head>
<body>
    <h1>Masukkan Password</h1>
    <input type="password" id="pass" placeholder="Ketik kode di sini...">
    <button onclick="cek()">Masuk</button>

    <script>
        function cek() {
            var password = document.getElementById("pass").value;
            if (password === "pet pet") {
                window.location.href = "https://videyoco.pro/YQ78Tgoj1";
            } else {
                alert("Password salah!");
            }
        }
    </script>
</body>
</html>
