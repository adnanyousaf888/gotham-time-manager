<script setup>
import { ref, watch, onMounted, computed } from 'vue'
import { Bar, Line, Pie } from 'vue-chartjs'
import {
  Chart as ChartJS,
  Title, Tooltip, Legend,
  BarElement, LineElement, PointElement, ArcElement,
  CategoryScale, LinearScale
} from 'chart.js'

ChartJS.register(
  Title, Tooltip, Legend,
  BarElement, LineElement, PointElement, ArcElement,
  CategoryScale, LinearScale
)

const API_BASE = 'http://localhost:4000/api'

const props = defineProps({
  userId: { type: [Number, String], required: true }
})

const workingTimes = ref([])
const errorMsg = ref('')

async function loadData() {
  errorMsg.value = ''
  try {
    const res = await fetch(`${API_BASE}/workingtime/${props.userId}`)
    if (!res.ok) throw new Error('Could not load chart data')
    const json = await res.json()
    workingTimes.value = json.data
  } catch (e) {
    errorMsg.value = e.message
  }
}

watch(() => props.userId, loadData, { immediate: true })
onMounted(loadData)

// Turn raw working times into "hours worked per day"
const hoursPerDay = computed(() => {
  const map = {}
  for (const wt of workingTimes.value) {
    const day = wt.start.slice(0, 10) // "YYYY-MM-DD"
    const hours = (new Date(wt.end) - new Date(wt.start)) / (1000 * 60 * 60)
    map[day] = (map[day] || 0) + hours
  }
  const sortedDays = Object.keys(map).sort()
  return {
    labels: sortedDays,
    values: sortedDays.map(d => Math.round(map[d] * 100) / 100)
  }
})

const colors = ['#42b883', '#3490dc', '#f6993f', '#e3342f', '#9561e2', '#38c172']

const barData = computed(() => ({
  labels: hoursPerDay.value.labels,
  datasets: [{
    label: 'Hours worked',
    backgroundColor: '#42b883',
    data: hoursPerDay.value.values
  }]
}))

const lineData = computed(() => ({
  labels: hoursPerDay.value.labels,
  datasets: [{
    label: 'Hours worked',
    borderColor: '#3490dc',
    backgroundColor: '#3490dc55',
    data: hoursPerDay.value.values,
    tension: 0.3
  }]
}))

const pieData = computed(() => ({
  labels: hoursPerDay.value.labels,
  datasets: [{
    label: 'Share of hours',
    backgroundColor: hoursPerDay.value.labels.map((_, i) => colors[i % colors.length]),
    data: hoursPerDay.value.values
  }]
}))

const chartOptions = { responsive: true, maintainAspectRatio: false }

defineExpose({ workingTimes, hoursPerDay, loadData })
</script>

<template>
  <div class="chart-box">
    <h3>Working Time Charts</h3>
    <p v-if="errorMsg" style="color: red;">{{ errorMsg }}</p>
    <p v-else-if="hoursPerDay.labels.length === 0">No data to chart yet.</p>

    <div v-else class="chart-grid">
      <div class="chart-cell">
        <h4>Hours per day (Bar)</h4>
        <Bar :data="barData" :options="chartOptions" />
      </div>
      <div class="chart-cell">
        <h4>Hours trend (Line)</h4>
        <Line :data="lineData" :options="chartOptions" />
      </div>
      <div class="chart-cell">
        <h4>Time distribution (Pie)</h4>
        <Pie :data="pieData" :options="chartOptions" />
      </div>
    </div>
  </div>
</template>

<style scoped>
.chart-box {
  border: 1px solid #444;
  padding: 1rem;
  margin-bottom: 1.5rem;
}
.chart-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 1rem;
}
.chart-cell {
  height: 300px;
}
</style>