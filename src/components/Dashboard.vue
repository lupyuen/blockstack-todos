<template>
  <div class="hello">
    <div class="container">
      <div class="row">
        <div class="col-md-8 col-md-offset-2">
          <h1 class="page-header">Blockstack Todo App
            <img :src="user.avatarUrl() ? user.avatarUrl() : '/avatar-placeholder.png'" class="avatar">
            <small><span class="sign-out">(<a href="#" @click.prevent="signOut">Sign Out</a>)</span></small>
          </h1>
          <h2 class="user-info">
            <small>
              {{ user.name() ? user.name() : 'Nameless Person'}}'s Todos
            </small>
            <small class="pull-right">
            {{ user.username ? user.username : user.identityAddress }}
            </small>

          </h2>
          <form @submit.prevent="addTodo" :disabled="! todo">
            <div class="input-group">
              <input v-model="todo" type="text" class="form-control" placeholder="Write a todo..." autofocus>
              <span class="input-group-btn">
                <button class="btn btn-default" type="submit" :disabled="! todo">Add</button>
              </span>
            </div>
          </form>

          <ul class="list-group">
            <li v-for="todo in todos"
              class="list-group-item"
              :class="{completed: todo.completed}"
              :key="todo.id">
              <label>
                <input type="checkbox" v-model="todo.completed">{{ todo.text }}
              </label>
              <a @click.prevent="todos.splice(todos.indexOf(todo), 1)"
                class="delete pull-right"
                href="#">X</a>
            </li>
          </ul>

        </div>
      </div>
    </div>
  </div>
</template>

<script>
//  List of partners authorised to access my sensor data and their public keys.
//  const PARTNER_FILE = 'partners.json'

const STORAGE_FILE = 'todos.json'

export default {
  name: 'dashboard',
  props: ['user'],
  data () {
    return {
      blockstack: window.blockstack,
      todos: [],
      todo: '',
      uidCount: 0
    }
  },
  watch: {
    todos: {
      handler: function (todos) {
        //  Todo list has been updated. Save to Gaia central storage.
        const blockstack = this.blockstack
        const encrypt = true

        //  Change the first todo.
        const updatedTodos = JSON.parse(JSON.stringify(todos))  //  Clone deep to prevent reactivity.
        if (updatedTodos[0]) updatedTodos[0].text = new Date().toISOString()
        console.log(JSON.stringify({ todos, updatedTodos }, null, 2))

        return blockstack.putFile(STORAGE_FILE, JSON.stringify(updatedTodos), encrypt)
      },
      deep: true
    }
  },
  mounted () {
    this.fetchData()
  },
  methods: {
    addTodo () {
      if (!this.todo.trim()) {
        return
      }
      this.todos.unshift({
        id: this.uidCount++,
        text: this.todo.trim(),
        completed: false
      })
      this.todo = ''
    },

    fetchData () {
      //  Upon startup, fetch list from Gaia central storage.
      const blockstack = this.blockstack
      const decrypt = true
      const username = 'lupyuen.id'
      // const username = 'iotsensor.id'
      const content = 'testing123'
      const encrypted = {  //  Encrypted with lupyuen.id
        iv: 'cc76e3510e0b85cc6559e71efa0b7399',
        ephemeralPK: '03a06e82ac145ca64b97907e9acf908c231dd9041778a6b430ae1c106e6705e99f',
        cipherText: 'f6e9a4e8be019ec1278f18d17ebfca7b',
        mac: 'e9246128e764a99324c9789f8d711f9791eb1ea9c0af0b52e625e0b2eb1b9221',
        wasString: true
      }

      blockstack.getFile(STORAGE_FILE, decrypt)
      .then((todosText) => {
        var todos = JSON.parse(todosText || '[]')
        todos.forEach(function (todo, index) {
          todo.id = index
        })
        this.uidCount = todos.length
        this.todos = todos
      })
        .then(() => this.getProfile(username))
        .then(() => {
          const encryptedContent = this.encryptContent(content)
          const decryptedContent = this.decryptContent(encryptedContent)
          console.log({ encryptedContent, decryptedContent }, JSON.stringify(encryptedContent))
        })
        .then(() => {
          const encryptedContent = this.encryptContent(content)
          const decryptedContent = this.decryptContent(encryptedContent)
          console.log({ encryptedContent, decryptedContent })
        })
        .then(() => {
          const encryptedJSON = JSON.stringify(encrypted)
          const decrypted = this.decryptContent(encryptedJSON)
          console.log({ decrypted })
        })
    },

    getProfile (username) {
      //  Fetch the profile of the user.
      //  TODO: Read the public encryption key
      const blockstack = this.blockstack
      return blockstack.lookupProfile(username)
        .then((profile) => {
          console.log({ profile })
        })
    },

    encryptContent (content) {
      //  Encrypt the content for the user.
      const blockstack = this.blockstack
      const encryptedContent = blockstack.encryptContent(content)
      console.log({ encryptedContent })
      return encryptedContent
    },

    decryptContent (content) {
      //  Decrypt the content for the user.
      const blockstack = this.blockstack
      const decryptedContent = blockstack.decryptContent(content)
      console.log({ decryptedContent })
      return decryptedContent
    },

    fetchData2 () {
      //  Lup Yuen
      let options = {
        user: 'ryan.id', // the Blockstack ID of the user for which to lookup the file
        app: 'http://BlockstackApp.com' // origin of the app this file is stored for
      }

      const blockstack = this.blockstack
      blockstack.getFile('/message.txt', options)
      .then((fileContents) => {
        // get the contents of the file /message.txt
        console.log({ fileContents })
      })
    },

    signOut () {
      this.blockstack.signUserOut(window.location.href)
    }
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style lang="scss" scoped>

input::placeholder {
  color: grey;
}

label {
  margin-bottom: 0;
  // width: 100%;
  cursor: pointer;
  input[type="checkbox"] {
    margin-right: 5px;
  }
}
.list-group-item {
  &.completed label {
    text-decoration: line-through;
  }

  .delete {
    display: none;
  }

  &:hover .delete {
    display: inline;
    color: grey;
    &:hover {
      text-decoration: none;
      color: red;
    }
  }
}
</style>
