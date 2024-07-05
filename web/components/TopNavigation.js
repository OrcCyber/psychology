import Link from "next/link";

export default function TopNavigation() {
  return (
    <nav className="nav shadow p-2 mb-3 justify-content-between">
      <div className="d-flex">
        <Link href="/home" className="nav-link">
          🏠 Home
        </Link>
        <Link href="/blog" className="nav-link">
          Blog
        </Link>
        <Link href="/about" className="nav-link">
          About us
        </Link>
      </div>
      <div className="d-flex">
        <Link href="/login" className="nav-link">
          Login
        </Link>
        <Link href="/register" className="nav-link">
          Register
        </Link>
      </div>
    </nav>
  );
}
