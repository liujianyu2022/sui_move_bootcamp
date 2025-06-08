import { BrowserRouter as Router, Route, Routes } from "react-router-dom";
import Main from "./pages/Main.tsx";
import User from "./pages/User.tsx";
import NaviBar from "./components/NaviBar.tsx";

function App() {
  return (    
    <Router>
      <div className="bg-background">
        <NaviBar />
        <Routes>
          <Route path="/" element={<Main />} />
          <Route path="/user" element={<User />} />
        </Routes>
      </div>
    </Router>
  );
}

export default App;
