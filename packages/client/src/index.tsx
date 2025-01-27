import "tailwindcss/tailwind.css";
import { StrictMode } from "react";
import { createRoot } from "react-dom/client";
import { Explorer } from "@/components/dev/explorer";
import { Providers } from "@/components/mud/providers";
import { ErrorBoundary } from "react-error-boundary";
import { ErrorFallback } from "./components/dev/error-fallback";
import { BrowserRouter, Route, Routes } from "react-router";

import { AppLayout } from "./components/app-layout";
import { Game } from "@/pages/game-scene";
import { Sessions } from "@/pages/sessions";

const root = document.getElementById("root");
if (!root) throw new Error("element with id root is not found");

createRoot(root).render(
  <StrictMode>
    <ErrorBoundary FallbackComponent={ErrorFallback}>
      <Providers>
        <BrowserRouter>
          <Routes>
            <Route element={<AppLayout />}>
              <Route index element={<Sessions />} />
              <Route path="/:session" element={<Game />} />
            </Route>
          </Routes>
        </BrowserRouter>
        <Explorer />
      </Providers>
    </ErrorBoundary>
  </StrictMode>
);
