import React from "react";
import { Link } from "react-router-dom";

export const Config: React.FC = () => {
  const some = {
    production: true,
    apiUrl: "http://localhost:34593",
  };

  return (
    <div>
      <pre>{JSON.stringify(some, null, 2)}</pre>
      <Link to={"/react"}>go back to base</Link>
    </div>
  );
};
