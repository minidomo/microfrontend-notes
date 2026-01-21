import { BrowserRouter, Route, Routes } from "react-router-dom";
import { Config } from "./config/config";
import { Base } from "./base/base";

export default function Root(props) {
  return (
    <BrowserRouter>
      <Routes>
        <Route path="react" element={<Base />} />
        <Route path="react/config" element={<Config />} />
      </Routes>
    </BrowserRouter>
  );
}
