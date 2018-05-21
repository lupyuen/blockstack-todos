<template>
  <div class="hello">
    <div>
      <h1>Blockstack Todo</h1>
      <p>A decentralized Todo app built on <a href="https://blockstack.org" target="_blank">Blockstack</a></p>
      <button class="btn btn-default" @click.prevent="signIn">Sign In With Blockstack</button>
    </div>
  </div>
</template>

<script>
export default {
  name: 'landing',
  data () {
    return {
      blockstack: window.blockstack
    }
  },

  methods: {
    signIn () {
      const blockstack = this.blockstack
      //  blockstack.redirectToSignIn()  //  Lup Yuen

      //  Lup Yuen: Get permission to publish data
      const origin = window.location.origin
      blockstack.redirectToSignIn(origin, origin + '/manifest.json', ['store_write', 'publish_data'])
    }
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
.hello {
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
}
</style>
