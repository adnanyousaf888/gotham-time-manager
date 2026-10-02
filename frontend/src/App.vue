<script setup>
import { ref } from 'vue'
import FeedbackForm from './components/FeedbackForm.vue'
import ManagerFeedbackDashboard from './components/ManagerFeedbackDashboard.vue'

// Simulated active session state. 
// Replace this with your actual auth state (e.g., localStorage, Pinia, or an Auth Context)
const currentUser = ref({
  id: 42,
  username: "Bruce Wayne",
  role: "employee" // Options: "employee", "manager", "admin"
})
</script>

<template>
  <div class="enterprise-layout">
    <!-- Left Navigation Sidebar -->
    <aside class="sidebar">
      <div class="sidebar-brand">
        <span class="brand-icon">⏱️</span>
        <div class="brand-text">
          <h2>TimeManager</h2>
          <p>Gotham Operations</p>
        </div>
      </div>

      <nav class="sidebar-menu">
        <div class="menu-group">Core Workspace</div>
        <RouterLink to="/user" class="menu-item">
          <span class="icon">👤</span> User Registry
        </RouterLink>
        <RouterLink to="/clock" class="menu-item">
          <span class="icon">⏱️</span> Shift Clock
        </RouterLink>
        <RouterLink to="/working-times" class="menu-item">
          <span class="icon">📅</span> Time Ledger
        </RouterLink>
        <RouterLink to="/dashboard" class="menu-item">
          <span class="icon">📊</span> Analytics Engine
        </RouterLink>

        <div class="menu-group">Communications</div>
        <RouterLink to="/feedback" class="menu-item">
          <span class="icon">📩</span> Submit Feedback
        </RouterLink>
        <RouterLink to="/admin/inbox" class="menu-item manager-secure-item">
          <span class="icon">🛡️</span> Executive Inbox
        </RouterLink>
      </nav>

      <div class="sidebar-footer">
        <div class="session-indicator">
          <span class="dot-online"></span>
          <span>Gateway: 4000 (Connected)</span>
        </div>
      </div>
    </aside>

    <!-- Main Dynamic Content Workspace -->
    <main class="main-viewport">
      <header class="viewport-context-bar">
        <div class="context-title">
          <h1>System Control Console</h1>
          <p>Role-authenticated workflow environment</p>
        </div>
      </header>
      <div class="view-surface">
        <RouterView />
      </div>
    </main>
  </div>
</template>

<style>
/* Global Modern Light-Mode Reset & Typography */
body {
  margin: 0;
  padding: 0;
  background-color: #ffffff; /* Crisp white foundation background */
  color: #1e293b; /* Charcoal body text for excellent readability */
  font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
}

.enterprise-layout {
  display: flex;
  min-height: 100vh;
}

/* Sidebar Layout Architecture (Light Steel Finish) */
.sidebar {
  width: 260px;
  background-color: #f8fafc; /* Crisp off-white panels */
  border-right: 1px solid #e2e8f0;
  display: flex;
  flex-direction: column;
  box-sizing: border-box;
}

.sidebar-brand {
  padding: 24px;
  display: flex;
  align-items: center;
  gap: 12px;
  border-bottom: 1px solid #e2e8f0;
}

.brand-icon {
  font-size: 22px;
  background-color: #e2e8f0;
  padding: 6px;
  border-radius: 6px;
}

.brand-text h2 {
  font-size: 16px;
  font-weight: 600;
  margin: 0;
  color: #0f172a;
}

.brand-text p {
  font-size: 11px;
  margin: 2px 0 0 0;
  color: #64748b;
  text-transform: uppercase;
  letter-spacing: 0.05em;
}

.sidebar-menu {
  flex: 1;
  padding: 20px 12px;
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.menu-group {
  font-size: 11px;
  font-weight: 700;
  text-transform: uppercase;
  color: #94a3b8;
  letter-spacing: 0.05em;
  padding: 12px 12px 6px 12px;
}

.menu-item {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 10px 12px;
  color: #475569;
  text-decoration: none;
  font-size: 14px;
  font-weight: 500;
  border-radius: 6px;
  transition: all 0.15s ease-in-out;
}

.menu-item:hover {
  color: #0f172a;
  background-color: #f1f5f9;
}

.menu-item .icon {
  font-size: 16px;
  opacity: 0.7;
}

/* Selected Active Navigation State (Navy Blueprint Anchor) */
.menu-item.router-link-active {
  color: #ffffff;
  background-color: #0f172a; 
  box-shadow: 0 4px 12px rgba(15, 23, 42, 0.1);
}

.menu-item.router-link-active .icon {
  opacity: 1;
}

.manager-secure-item {
  border: 1px dashed #cbd5e1;
}

.manager-secure-item.router-link-active {
  background-color: #0369a1; /* Specialized deep blue accent for administrative access */
  box-shadow: 0 4px 12px rgba(3, 105, 161, 0.1);
  border-color: transparent;
}

.sidebar-footer {
  padding: 16px;
  border-top: 1px solid #e2e8f0;
  background-color: #f1f5f9;
}

.session-indicator {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 12px;
  color: #64748b;
}

.dot-online {
  width: 6px;
  height: 6px;
  background-color: #10b981;
  border-radius: 50%;
  box-shadow: 0 0 6px #10b981;
}

/* Viewport Surface Architecture */
.main-viewport {
  flex: 1;
  display: flex;
  flex-direction: column;
  background-color: #ffffff;
}

.viewport-context-bar {
  background-color: #ffffff;
  border-bottom: 1px solid #e2e8f0;
  padding: 16px 32px;
}

.context-title h1 {
  font-size: 18px;
  font-weight: 600;
  margin: 0;
  color: #0f172a;
}

.context-title p {
  font-size: 12px;
  color: #64748b;
  margin: 4px 0 0 0;
}

.view-surface {
  padding: 32px;
  flex: 1;
  overflow-y: auto;
  box-sizing: border-box;
}
</style>
