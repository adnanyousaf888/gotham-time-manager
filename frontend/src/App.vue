<script setup>
import { ref } from 'vue'
import User from './components/User.vue'
import ClockManager from './components/ClockManager.vue'

const currentUser = ref(null)
</script>

<template>
  <div id="app">
    <h1>Time Manager</h1>

    <User v-model="currentUser" />

    <div v-if="currentUser">
      <ClockManager :userId="currentUser.id" />
    </div>
  </div>
</template>

<style scoped>
</style>