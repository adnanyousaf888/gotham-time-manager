<template>
  <div class="form-surface-card">
    <div class="card-header-block">
      <h3>Operational Escalation Form</h3>
      <p>Submit discrepancies, compliance flags, or operational adjustments directly to leadership rosters.</p>
    </div>

    <form @submit.prevent="submitFeedback" class="clean-form-flow">
      <div class="input-field-group">
        <label>Destination Route</label>
        <select v-model.number="form.receiver_id" class="corporate-select" required>
          <option value="" disabled selected>Select an authority node...</option>
          <option value="1">Administrative Director (Albert)</option>
          <option value="2">Tactical Field Lead (Gordon)</option>
          <option value="3">Human Allocation Board (HR)</option>
        </select>
      </div>

      <div class="input-field-group">
        <label>Subject Context</label>
        <input 
          v-model="form.subject" 
          type="text" 
          placeholder="Summary of discrepancy or tracking adjustment"
          class="corporate-input"
          required
        />
      </div>

      <div class="input-field-group">
        <label>Detailed Exposition</label>
        <textarea 
          v-model="form.description" 
          rows="5" 
          placeholder="State full context, logs metrics, and justification records..."
          class="corporate-textarea"
          required
        ></textarea>
      </div>

      <button type="submit" class="corporate-primary-btn">
        Transmit Communication
      </button>
    </form>
  </div>
</template>

<script setup>
import { ref } from 'vue'

const form = ref({
  subject: '',
  description: '',
  user_id: 1,        
  receiver_id: ''   
})

const submitFeedback = async () => {
  try {
    const response = await fetch('http://localhost:4000/api/feedbacks', {
      method: 'POST',
      headers: { 
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
      body: JSON.stringify({ feedback: form.value })
    })
    
    if (response.ok) {
      alert('Feedback successfully submitted across team channels!')
      form.value.subject = ''
      form.value.description = ''
      form.value.receiver_id = ''
    } else {
      alert('Submission failed.')
    }
  } catch (error) {
    console.error('API Connection Broken:', error)
  }
}
</script>

<style scoped>
/* Crisp white component wrapper background */
.form-surface-card {
  background-color: #ffffff;
  border: 1px solid #e2e8f0;
  border-radius: 8px;
  padding: 32px;
  max-width: 550px;
  margin: 0 auto;
  box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05), 0 2px 4px -1px rgba(0, 0, 0, 0.03);
}

.card-header-block {
  margin-bottom: 24px;
}

.card-header-block h3 {
  font-size: 18px;
  font-weight: 600;
  color: #0f172a; /* Clear dark text */
  margin: 0 0 6px 0;
}

.card-header-block p {
  font-size: 14px;
  color: #475569; /* Muted corporate summary text */
  margin: 0;
  line-height: 1.5;
}

.clean-form-flow {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.input-field-group {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.input-field-group label {
  font-size: 12px;
  font-weight: 600;
  color: #475569;
  text-transform: uppercase;
  letter-spacing: 0.02em;
}

/* Bright clean light fields with clear charcoal font color text tracking grids */
.corporate-input, .corporate-select, .corporate-textarea {
  background-color: #f8fafc;
  border: 1px solid #cbd5e1;
  border-radius: 6px;
  padding: 10px 14px;
  color: #0f172a;
  font-size: 14px;
  font-family: inherit;
  transition: all 0.1s ease-in-out;
}

.corporate-input::placeholder, .corporate-textarea::placeholder {
  color: #94a3b8;
}

.corporate-input:focus, .corporate-select:focus, .corporate-textarea:focus {
  outline: none;
  background-color: #ffffff;
  border-color: #2563eb;
  box-shadow: 0 0 0 1px #2563eb;
}

.corporate-textarea {
  resize: none;
  line-height: 1.5;
}

.corporate-primary-btn {
  background-color: #2563eb;
  color: #ffffff;
  border: none;
  padding: 12px;
  font-size: 14px;
  font-weight: 600;
  border-radius: 6px;
  cursor: pointer;
  transition: background-color 0.1s ease;
}

.corporate-primary-btn:hover {
  background-color: #1d4ed8;
}
</style>
