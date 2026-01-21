import React from "react";
import { Link } from "react-router-dom";
import { navigateToUrl } from "single-spa";

export const Base: React.FC = () => {
  return (
    <div>
      <div>this is react</div>
      <Link to={"/react/config"}>view react config</Link>
      <br />
      <a href="/angular/config" onClick={navigateToUrl}>
        go to angular config
      </a>
    </div>
  );
};
