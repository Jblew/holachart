<template>
  <div class="hello">
    <h1 style="color: purple">Demo: {{ msg }}</h1>
  </div>
</template>

<script lang="ts">
import { Component, Prop, Vue } from "vue-property-decorator";

@Component
export default class Graph extends Vue {
  @Prop() private msg!: string;
}
</script>
