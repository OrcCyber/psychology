import "bootstrap/dist/css/bootstrap.css";

import TopNavigation from "@/components/TopNavigation";

export const metadata = {
  title: "Someone",
  description: "Someone App",
};

export default function RootLayout({ children }) {
  return (
    <html lang="en">
      <body>
        <TopNavigation />
        {children}
      </body>
    </html>
  );
}
