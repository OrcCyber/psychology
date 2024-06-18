/project-root
│
├── /backend
│ ├── /config
│ │ └── db.js # File cấu hình cơ sở dữ liệu
│ ├── /controllers
│ │ └── userController.js # Các logic xử lý yêu cầu
│ ├── /models
│ │ └── userModel.js # Các schema của MongoDB
│ ├── /routes
│ │ └── userRoutes.js # Các định tuyến API
│ ├── /middlewares
│ │ └── authMiddleware.js # Các middleware
│ ├── /utils
│ │ └── utils.js # Các hàm tiện ích chung
│ ├── .env # File cấu hình môi trường
│ ├── server.js # File entry chính của backend
│ └── package.json # File cấu hình npm cho backend
│
├── /frontend
│ ├── /public
│ │ └── index.html # File HTML chính
│ ├── /src
│ │ ├── /components
│ │ │ └── Navbar.js # Các thành phần giao diện React
│ │ ├── /pages
│ │ │ └── HomePage.js # Các trang chính của ứng dụng
│ │ ├── /services
│ │ │ └── api.js # Các lời gọi API
│ │ ├── /contexts
│ │ │ └── AuthContext.js # Các context của React
│ │ ├── /hooks
│ │ │ └── useAuth.js # Các custom hook
│ │ ├── /styles
│ │ │ └── App.css # Các file CSS
│ │ ├── App.js # File entry chính của React
│ │ └── index.js # File entry chính của ReactDOM
│ └── package.json # File cấu hình npm cho frontend
│
├── .gitignore # File cấu hình git
├── README.md # File hướng dẫn dự án
└── package.json # File cấu hình npm chung (nếu cần)
