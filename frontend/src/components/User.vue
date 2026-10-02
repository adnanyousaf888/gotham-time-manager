<template>
  <div class="user-registry-container">
    
    <!-- Section A: Register New Employee -->
    <div class="registry-card">
      <div class="card-header">
        <h3>Create New Team Profile</h3>
        <p>Register a new worker account node within the Gotham system directory.</p>
      </div>

      <form @submit.prevent="registerUser" class="form-flow">
        <div class="form-group">
          <label>Full Username</label>
          <input 
            v-model="newUser.username" 
            type="text" 
            placeholder="e.g., John Doe" 
            class="light-input"
            required 
          />
        </div>
        <div class="form-group">
          <label>Email Address</label>
          <input 
            v-model="newUser.email" 
            type="email" 
            placeholder="e.g., john.doe@gotham.gov" 
            class="light-input"
            required 
          />
        </div>
        <button type="submit" class="primary-btn">Create User Account</button>
      </form>
    </div>

    
    <div class="registry-card search-card">
      <div class="card-header">
        <h3>Load Existing Profile</h3>
        <p>Search and verify an existing employee profile by ID, username, or email to initialize your session.</p>
      </div>

      <div class="form-flow">
        <div class="form-group">
          <label>Search Identifier (ID, Username, or Email)</label>
          <div class="search-input-wrapper">
            <!-- EXTENDED STANDALONE TARGET BAR WITH EXPLICIT FLEX GROWS -->
            <input 
              v-model="searchQuery" 
              type="text" 
              placeholder="Type exact database ID, username, or email address here..." 
              class="light-input search-large-bar"
              @keyup.enter="searchAndLoadUser"
            />
            <button @click="searchAndLoadUser" class="secondary-btn search-large-btn">Search Profile</button>
          </div>
        </div>
      </div>

      <!-- Active Session Status Alert Indicator -->
      <div v-if="activeUser" class="active-session-banner">
        <div class="banner-title">
          <span class="active-dot"></span>
          <h4>Active Employee Session Loaded</h4>
        </div>
        <div class="session-details">
          <p><strong>Database ID:</strong> #{{ activeUser.id }}</p>
          <p><strong>Username:</strong> {{ activeUser.username }}</p>
          <p><strong>Email:</strong> {{ activeUser.email }}</p>
        </div>
        <button @click="clearSession" class="clear-btn">Unload Profile</button>
      </div>
    </div>

  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'

const searchQuery = ref('')
const activeUser = ref(null)

const newUser = ref({
  username: '',
  email: ''
})

const registerUser = async () => {
  try {
    const response = await fetch('http://localhost:4000/api/users', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
      body: JSON.stringify({ user: newUser.value })
    })

    if (response.ok) {
      const jsonResponse = await response.json()
      const createdUser = jsonResponse.data
      alert(`User profile created successfully! ID: #${createdUser.id}`)
      saveUserSession(createdUser)
      newUser.value.username = ''
      newUser.value.email = ''
    } else {
      const err = await response.json()
      alert('Failed to register account: ' + JSON.stringify(err.errors))
    }
  } catch (error) {
    console.error('Registration API Error:', error)
  }
}

const searchAndLoadUser = async () => {
  const query = searchQuery.value.trim()
  if (!query) return

  try {
    if (/^\d+\$/.test(query)) {
      const response = await fetch(`http://localhost:4000/api/users/${query}`, {
        method: 'GET',
        headers: { 'Accept': 'application/json' }
      })

      if (response.ok) {
        const jsonResponse = await response.json()
        saveUserSession(jsonResponse.data)
        searchQuery.value = ''
        alert(`Session updated successfully for loaded ID: #${jsonResponse.data.id}`)
        return
      }
    }

    const response = await fetch('http://localhost:4000/api/users', {
      method: 'GET',
      headers: { 'Accept': 'application/json' }
    })

    if (response.ok) {
      const jsonResponse = await response.json()
      const usersList = jsonResponse.data

      const matched = usersList.find(u => 
        u.email.toLowerCase() === query.toLowerCase() ||
        u.username.toLowerCase() === query.toLowerCase() ||
        String(u.id) === query
      )

      if (matched) {
        saveUserSession(matched)
        searchQuery.value = ''
        alert(`Session updated successfully for: ${matched.username}`)
      } else {
        alert('No matching employee record discovered in database.')
      }
    }
  } catch (error) {
    console.error('User search API Error:', error)
    alert('Failed to verify profile information with the server.')
  }
}

const saveUserSession = (user) => {
  activeUser.value = user
  localStorage.setItem('current_user_id', user.id)
  localStorage.setItem('current_user_name', user.username)
  localStorage.setItem('current_user_email', user.email || 'Stored locally')
}

const clearSession = () => {
  activeUser.value = null
  localStorage.removeItem('current_user_id')
  localStorage.removeItem('current_user_name')
  localStorage.removeItem('current_user_email')
  alert('Profile session wiped successfully.')
}

onMounted(() => {
  const storedId = localStorage.getItem('current_user_id')
  if (storedId) {
    activeUser.value = {
      id: storedId,
      username: localStorage.getItem('current_user_name') || 'Loaded Employee',
      email: localStorage.getItem('current_user_email') || 'Stored locally'
    }
  }
})
</script>

<style scoped>
.user-registry-container {
  display: flex;
  flex-direction: column;
  gap: 32px;
  max-width: 850px;
  margin: 0 auto;
  padding: 16px 0;
  box-sizing: border-box;
}

.registry-card {
  background-color: #ffffff;
  border: 1px solid #e2e8f0;
  border-radius: 8px;
  padding: 36px 40px;
  box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);
  box-sizing: border-box;
  width: 100%;
}

.card-header {
  margin-bottom: 28px;
  border-bottom: 1px solid #f1f5f9;
  padding-bottom: 14px;
}

.card-header h3 {
  font-size: 20px;
  font-weight: 600;
  color: #0f172a;
  margin: 0 0 8px 0;
}

.card-header p {
  font-size: 14px;
  color: #475569;
  margin: 0;
  line-height: 1.5;
}

.form-flow {
  display: flex;
  flex-direction: column;
  gap: 22px;
}

.form-group {
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.form-group label {
  font-size: 13px;
  font-weight: 600;
  color: #334155;
  text-transform: uppercase;
  letter-spacing: 0.03em;
}

.light-input {
  background-color: #f8fafc;
  border: 1px solid #cbd5e1;
  border-radius: 6px;
  padding: 12px 16px;
  color: #0f172a;
  font-size: 14px;
  width: 100%;
  box-sizing: border-box;
}

.light-input:focus {
  outline: none;
  background-color: #ffffff;
  border-color: #2563eb;
  box-shadow: 0 0 0 1px #2563eb;
}

/* CRITICAL OVERRIDES: FORCES THE INPUT BAR TO STRETCH IN FLEX ROW WINDOWS */
.search-input-wrapper {
  display: flex !important;
  align-items: center !important;
  gap: 16px !important;
  width: 100% !important;
}

.search-large-bar {
  display: block !important;
  flex: 1 1 auto !important; /* Forces the box to take up all available empty layout space */
  width: 100% !important;   /* Breaks the tiny collapsed square profile rule */
  min-width: 200px !important;
  padding: 14px 20px !important;
  font-size: 15px !important;
  box-sizing: border-box !important;
}

.search-large-btn {
  flex: 0 0 auto !important; /* Prevents button itself from stretching weirdly */
  padding: 14px 28px !important;
  font-size: 15px !important;
  white-space: nowrap !important;
}

.primary-btn {
  background-color: #2563eb;
  color: #ffffff;
  border: none;
  padding: 14px;
  font-size: 14px;
  font-weight: 600;
  border-radius: 6px;
  cursor: pointer;
  transition: background-color 0.1s;
  width: 100%;
  margin-top: 8px;
}

.primary-btn:hover { background-color: #1d4ed8; }

.secondary-btn {
  background-color: #f1f5f9;
  color: #0f172a;
  border: 1px solid #cbd5e1;
  padding: 12px 24px;
  border-radius: 6px;
  font-weight: 600;
  font-size: 14px;
  cursor: pointer;
  white-space: nowrap;
  transition: all 0.1s;
}

.secondary-btn:hover { background-color: #e2e8f0; }

.active-session-banner {
  margin-top: 28px;
  background-color: #f0fdf4;
  border: 1px solid #bbf7d0;
  border-radius: 6px;
  padding: 20px;
}

.banner-title {
  display: flex;
  align-items: center;
  gap: 10px;
  margin-bottom: 14px;
}

.banner-title h4 {
  margin: 0;
  color: #166534;
  font-size: 15px;
  font-weight: 600;
}

.active-dot {
  width: 10px;
  height: 10px;
  background-color: #22c55e;
  border-radius: 50%;
  display: inline-block;
  box-shadow: 0 0 6px #22c55e;
}

.session-details {
  display: flex;
  flex-direction: column;
  gap: 6px;
  background-color: rgba(255, 255, 255, 0.5);
  padding: 12px 16px;
  border-radius: 4px;
  border: 1px solid rgba(191, 239, 208, 0.5);
}

.session-details p {
  margin: 0;
  font-size: 14px;
  color: #14532d;
}

.clear-btn {
  margin-top: 16px;
  background-color: transparent;
  color: #b91c1c;
  border: 1px solid #fca5a5;
  padding: 8px 16px;
  font-size: 13px;
  font-weight: 600;
  border-radius: 4px;
  cursor: pointer;
  transition: all 0.1s;
}

.clear-btn:hover { background-color: #fef2f2; }
</style>
