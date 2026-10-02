<template>
  <div class="ledger-surface-card">
    <div class="ledger-header">
      <div>
        <h3>Executive Communication Stream</h3>
        <p class="subtitle">Secure administrative transmission records for audit review.</p>
      </div>
      <button @click="fetchFeedbacks" class="corporate-secondary-btn">
        Refresh Records
      </button>
    </div>

    <!-- Empty State -->
    <div v-if="feedbacks.length === 0" class="ledger-empty">
      No transmission logs resolved within this reporting node block.
    </div>

    <!-- Audit Log Feed List -->
    <div v-else class="ledger-list-table">
      <div v-for="item in feedbacks" :key="item.id" class="ledger-row-card">
        <div class="row-meta-bar">
          <div class="meta-indicators">
            <span class="audit-id-badge">LOG #{{ item.id }}</span>
            <span class="origin-tag">Origin Node ID: {{ item.user_id }}</span>
          </div>
          <span class="status-indicator-badge">Unprocessed</span>
        </div>
        <h4 class="ledger-row-subject">{{ item.subject }}</h4>
        <p class="ledger-row-desc">{{ item.description }}</p>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'

const feedbacks = ref([])

// Async network call to fetch data items from your Phoenix backend
const fetchFeedbacks = async () => {
  try {
    const response = await fetch('http://localhost:4000/api/feedbacks', {
      method: 'GET',
      headers: {
        'Accept': 'application/json'
      }
    })
    if (response.ok) {
      const jsonResponse = await response.json()
      feedbacks.value = jsonResponse.data
    } else {
      console.error('Failed to load logs from server endpoint.')
    }
  } catch (error) {
    console.error('Handshake error synchronizing backend data payload:', error)
  }
}

onMounted(() => {
  fetchFeedbacks()
})
</script>

<style scoped>
/* Clean light panel block with soft shadows */
.ledger-surface-card {
  background-color: #ffffff;
  border: 1px solid #e2e8f0;
  border-radius: 8px;
  padding: 32px;
  max-width: 900px;
  margin: 0 auto;
  box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);
}

.ledger-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 28px;
  border-bottom: 1px solid #e2e8f0;
  padding-bottom: 16px;
}

.ledger-header h3 {
  font-size: 18px;
  font-weight: 600;
  color: #0f172a;
  margin: 0 0 4px 0;
}

.subtitle {
  font-size: 14px;
  color: #475569;
  margin: 0;
}

.corporate-secondary-btn {
  background-color: #f8fafc;
  color: #0f172a;
  border: 1px solid #cbd5e1;
  padding: 8px 14px;
  border-radius: 6px;
  font-size: 13px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.1s ease;
}

.corporate-secondary-btn:hover {
  background-color: #f1f5f9;
  border-color: #94a3b8;
}

.ledger-empty {
  padding: 48px;
  text-align: center;
  background-color: #f8fafc;
  border: 1px dashed #cbd5e1;
  border-radius: 6px;
  color: #64748b;
  font-size: 14px;
}

.ledger-list-table {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

/* Row card panels matching white/light layout grids */
.ledger-row-card {
  background-color: #f8fafc;
  border: 1px solid #e2e8f0;
  border-radius: 6px;
  padding: 20px;
}

.row-meta-bar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 12px;
}

.meta-indicators {
  display: flex;
  align-items: center;
  gap: 12px;
}

.audit-id-badge {
  background-color: #e2e8f0;
  color: #334155;
  padding: 2px 6px;
  border-radius: 4px;
  font-size: 11px;
  font-weight: 700;
  font-family: monospace;
}

.origin-tag {
  font-size: 12px;
  color: #64748b;
}

.status-indicator-badge {
  background-color: #fef3c7; /* Soft amber status tint */
  color: #b45309;
  border: 1px solid #fde68a;
  font-size: 11px;
  font-weight: 600;
  padding: 2px 8px;
  border-radius: 9999px;
}

.ledger-row-subject {
  font-size: 16px;
  font-weight: 600;
  color: #0f172a;
  margin: 0 0 8px 0;
}

.ledger-row-desc {
  font-size: 14px;
  color: #334155;
  margin: 0;
  line-height: 1.5;
  background-color: #ffffff;
  padding: 12px;
  border-radius: 4px;
  border: 1px solid #e2e8f0;
  border-left: 3px solid #64748b;
}
</style>
