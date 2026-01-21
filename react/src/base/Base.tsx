import React from "react";
import { Link } from "react-router-dom";

export const Base: React.FC = () => {
  return (
    <div>
      <div>this is react</div>
      <Link to={"/react/config"}>view react config</Link>
    </div>
  );
};
