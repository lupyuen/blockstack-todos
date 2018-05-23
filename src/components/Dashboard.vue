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
      const username = 'ID-1PGgFRe5F8Q1YdepbaWU1b4hdMegLztnAf'

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
    },

    getProfile (username) {
      //  Fetch the profile of the user.
      //  TODO: Read the public encryption key
      const blockstack = this.blockstack
      console.log({ blockstack })
      return blockstack.lookupProfile(username)
        .then((profile) => {
          console.log({ profile })
        })
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
