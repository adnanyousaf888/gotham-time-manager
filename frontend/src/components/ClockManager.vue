<script setup>
import { ref, watch, onMounted } from 'vue'

const API_BASE = 'http://localhost:4000/api'

const props = defineProps({
  userId: { type: [Number, String], required: true }
})

const startDateTime = ref(null)
const clockIn = ref(false)
const errorMsg = ref('')

async function refresh() {
  errorMsg.value = ''
  try {
    const res = await fetch(`${API_BASE}/clocks/${props.userId}`)
    if (!res.ok) throw new Error('Could not load clock history')
    const json = await res.json()
    const clocks = json.data

    if (clocks.length === 0) {
      clockIn.value = false
      startDateTime.value = null
      return
    }

    const last = clocks[clocks.length - 1]
    clockIn.value = last.status
    startDateTime.value = last.status ? last.time : null
  } catch (e) {
    errorMsg.value = e.message
  }
}

async function clock() {
  errorMsg.value = ''
  try {
    const res = await fetch(`${API_BASE}/clocks/${props.userId}`, { method: 'POST' })
    if (!res.ok) throw new Error('Clock action failed')
    const json = await res.json()
    clockIn.value = json.data.status
    startDateTime.value = json.data.status ? json.data.time : null
  } catch (e) {
    errorMsg.value = e.message
  }
}

watch(() => props.userId, refresh, { immediate: true })
onMounted(refresh)

defineExpose({ startDateTime, clockIn, refresh, clock })
</script>

<template>
  <div class="clock-box">
    <h3>Clock</h3>
    <p v-if="clockIn">
      Currently clocked in since <strong>{{ startDateTime }}</strong>
    </p>
    <p v-else>Currently clocked out.</p>

    <button @click="clock">
      {{ clockIn ? 'Clock Out' : 'Clock In' }}
    </button>

    <p v-if="errorMsg" style="color: red;">{{ errorMsg }}</p>
  </div>
</template>

<style scoped>
.clock-box {
  border: 1px solid #444;
  padding: 1rem;
  margin-bottom: 1.5rem;
}
</style>