<script setup>
import { ref, watch, onMounted } from 'vue'

const API_BASE = 'http://localhost:4000/api'

const props = defineProps({
  userId: { type: [Number, String], required: true }
})

defineEmits(['delete-clicked'])

const workingTimes = ref([])
const errorMsg = ref('')

function formatDate(iso) {
  if (!iso) return ''
  const d = new Date(iso)
  const pad = (n) => String(n).padStart(2, '0')
  return `${d.getFullYear()}-${pad(d.getMonth() + 1)}-${pad(d.getDate())} ${pad(d.getHours())}:${pad(d.getMinutes())}:${pad(d.getSeconds())}`
}

async function getWorkingTimes() {
  errorMsg.value = ''
  try {
    const res = await fetch(`${API_BASE}/workingtime/${props.userId}`)
    if (!res.ok) throw new Error('Could not load working times')
    const json = await res.json()
    workingTimes.value = json.data
  } catch (e) {
    errorMsg.value = e.message
  }
}

watch(() => props.userId, getWorkingTimes, { immediate: true })
onMounted(getWorkingTimes)

defineExpose({ userId: props.userId, workingTimes, getWorkingTimes })
</script>

<template>
  <div class="wt-box">
    <h3>Working Times</h3>
    <table v-if="workingTimes.length">
      <thead>
        <tr>
          <th>ID</th>
          <th>Start</th>
          <th>End</th>
          <th></th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="wt in workingTimes" :key="wt.id">
          <td>{{ wt.id }}</td>
          <td>{{ formatDate(wt.start) }}</td>
          <td>{{ formatDate(wt.end) }}</td>
          <td>
            <button @click="$emit('delete-clicked', wt.id)">Delete</button>
          </td>
        </tr>
      </tbody>
    </table>
    <p v-else>No working times recorded yet.</p>

    <p v-if="errorMsg" style="color: red;">{{ errorMsg }}</p>
  </div>
</template>

<style scoped>
.wt-box {
  border: 1px solid #444;
  padding: 1rem;
  margin-bottom: 1.5rem;
}
table {
  border-collapse: collapse;
  width: 100%;
}
th, td {
  border: 1px solid #444;
  padding: 0.4rem 0.6rem;
  text-align: left;
}
</style>