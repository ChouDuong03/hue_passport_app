const express = require('express');
const cors = require('cors');
const app = express();
const port = 3000;

app.use(cors());

app.get('/api/home', (req, res) => {
  res.json({
    userName: "Kevin Nguyen",
    program: {
      title: "Chương trình tham quan Huế",
      description: "Đại Nội, lầu Ngũ Phụng, Điện Thái Hòa, Duyệt Thị Đường, chùa Thiên Mụ, Văn Thánh",
      places: 10,
      participants: "67,9k",
      imageUrl: "https://yourdomain.com/assets/hue.jpg"
    },
    luckyDraw: {
      totalWinners: 10
    },
    completedPrograms: 3401,
    todayRegistration: 38,
    recentCheckins: [
      {
        name: "Robert Downey J.",
        code: "MHC036719"
      }
    ]
  });
});

app.listen(port, () => {
  console.log(`✅ API đang chạy tại http://localhost:${port}/api/home`);
});
