"use client";
import { useState } from "react";

export default function Register() {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [confirmPassword, setConfirmPassword] = useState("");
  const [loading, setLoading] = useState(false);

  const submit = async (e) => {
    e.preventDefault();
  };

  return (
    <main>
      <div className="container">
        <div className="row d-flex justify-content-center">asdasdaajshd</div>
      </div>
    </main>
  );
}
