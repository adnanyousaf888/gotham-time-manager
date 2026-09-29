<script setup>
import { ref } from 'vue'

const API_BASE = 'http://localhost:4000/api'

const props = defineProps({
  userId: { type: [Number, String], required: true }
})

const emit = defineEmits(['saved'])

const startInput = ref('')
const endInput = ref('')
const editingId = ref(null)
const errorMsg = ref('')

function toIso(localValue) {
  // localValue comes from <input type="datetime-local"> as "YYYY-MM-DDTHH:mm"
  return localValue ? `${localValue}:00Z` : null
}

async function createWorkingTime() {
  errorMsg.value = ''
  try {
    const res = await fetch(`${API_BASE}/workingtime/${props.userId}`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        working_time: { start: toIso(startInput.value), end: toIso(endInput.value) }
      })
    })
    if (!res.ok) throw new Error('Could not create working time')
    startInput.value = ''
    endInput.value = ''
    emit('saved')
  } catch (e) {
    errorMsg.value = e.message
  }
}

async function updateWorkingTime(id, fields) {
  errorMsg.value = ''
  try {
    const res = await fetch(`${API_BASE}/workingtime/${id}`, {
      method: 'PUT',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ working_time: fields })
    })
    if (!res.ok) throw new Error('Could not update working time')
    emit('saved')
  } catch (e) {
    errorMsg.value = e.message
  }
}

async function deleteWorkingTime(id) {
  errorMsg.value = ''
  try {
    await fetch(`${API_BASE}/workingtime/${id}`, { method: 'DELETE' })
    emit('saved')
  } catch (e) {
    errorMsg.value = e.message
  }
}

defineExpose({ createWorkingTime, updateWorkingTime, deleteWorkingTime })
</script>

<template>
  <div class="wt-form-box">
    <h3>Add a Working Time</h3>
    <label>
      Start:
      <input type="datetime-local" v-model="startInput" />
    </label>
    <label>
      End:
      <input type="datetime-local" v-model="endInput" />
    </label>
    <button @click="createWorkingTime">Save</button>

    <p v-if="errorMsg" style="color: red;">{{ errorMsg }}</p>
  </div>
</template>

<style scoped>
.wt-form-box {
  border: 1px solid #444;
  padding: 1rem;
  margin-bottom: 1.5rem;
}
label {
  display: block;
  margin: 0.4rem 0;
}
</style>