import React from "react";
import { Link } from "react-router-dom";
import { environment } from "../environment";

export const Config: React.FC = () => {
  const some = {
    production: true,
    apiUrl: environment.apiUrl,
  };

  return (
    <div>
      <pre>{JSON.stringify(some, null, 2)}</pre>
      <Link to={"/react"}>go back to base</Link>
    </div>
  );
};
