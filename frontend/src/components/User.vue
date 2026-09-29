<script setup>
import { ref } from 'vue'

const API_BASE = 'http://localhost:4000/api'

const props = defineProps({
  modelValue: Object
})
const emit = defineEmits(['update:modelValue'])

const searchId = ref('')
const newUsername = ref('')
const newEmail = ref('')
const errorMsg = ref('')

async function getUser() {
  errorMsg.value = ''
  if (!searchId.value) {
    errorMsg.value = 'Enter a user ID to load.'
    return
  }
  try {
    const res = await fetch(`${API_BASE}/users/${searchId.value}`)
    if (!res.ok) throw new Error('User not found')
    const json = await res.json()
    emit('update:modelValue', json.data)
  } catch (e) {
    errorMsg.value = e.message
  }
}

async function createUser() {
  errorMsg.value = ''
  try {
    const res = await fetch(`${API_BASE}/users`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ user: { username: newUsername.value, email: newEmail.value } })
    })
    if (!res.ok) throw new Error('Could not create user (check email format)')
    const json = await res.json()
    emit('update:modelValue', json.data)
    newUsername.value = ''
    newEmail.value = ''
  } catch (e) {
    errorMsg.value = e.message
  }
}

async function updateUser(fields) {
  if (!props.modelValue) return
  const res = await fetch(`${API_BASE}/users/${props.modelValue.id}`, {
    method: 'PUT',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ user: fields })
  })
  if (!res.ok) throw new Error('Update failed')
  const json = await res.json()
  emit('update:modelValue', json.data)
}

async function deleteUser() {
  if (!props.modelValue) return
  await fetch(`${API_BASE}/users/${props.modelValue.id}`, { method: 'DELETE' })
  emit('update:modelValue', null)
}

defineExpose({ createUser, updateUser, getUser, deleteUser })
</script>

<template>
  <div class="user-box">
    <div v-if="modelValue">
      <p><strong>Current user:</strong> {{ modelValue.username }} ({{ modelValue.email }}) — ID {{ modelValue.id }}</p>
      <button @click="deleteUser">Delete this user</button>
      <button @click="emit('update:modelValue', null)">Switch user</button>
    </div>

    <div v-else>
      <h3>Load an existing employee</h3>
      <input v-model="searchId" placeholder="User ID" />
      <button @click="getUser">Load</button>

      <h3>Or register a new employee</h3>
      <input v-model="newUsername" placeholder="Username" />
      <input v-model="newEmail" placeholder="Email" />
      <button @click="createUser">Create</button>

      <p v-if="errorMsg" style="color: red;">{{ errorMsg }}</p>
    </div>
  </div>
</template>

<style scoped>
.user-box {
  border: 1px solid #444;
  padding: 1rem;
  margin-bottom: 1.5rem;
}
input {
  display: block;
  margin: 0.3rem 0;
}
</style>