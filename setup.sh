#!/bin/bash

set -e  # Detener en errores

echo "🚀 Script de instalación para el proyecto 'misnotas-ejemplo'"
read -p "¿Deseas comenzar la instalación paso a paso? (s/n): " confirm
[[ "$confirm" != "s" ]] && echo "❌ Instalación cancelada." && exit 1

echo "👉 Paso 1: Crear el proyecto con Vite + React"
read -p "¿Ejecutar 'npm create vite@latest misnotas-ejemplo -- --template react'? (s/n): " step1
if [[ "$step1" == "s" ]]; then
  npm create vite@latest misnotas-ejemplo -- --template react
else
  echo "⏭ Saltando paso 1"
fi

cd misnotas-ejemplo || { echo "❌ No se pudo entrar al directorio misnotas-ejemplo"; exit 1; }

echo "👉 Paso 2: Instalar dependencias base"
read -p "¿Instalar dependencias con 'npm install'? (s/n): " step2
if [[ "$step2" == "s" ]]; then
  npm install
else
  echo "⏭ Saltando paso 2"
fi

echo "👉 Paso 3: Instalar TailwindCSS y configuraciones"
read -p "¿Deseas instalar Tailwind CSS? (s/n): " step3
if [[ "$step3" == "s" ]]; then
  npm install -D tailwindcss postcss autoprefixer
  npx tailwindcss init -p
else
  echo "⏭ Saltando paso 3"
fi

echo "👉 Paso 4: Configurar TailwindCSS"
read -p "¿Sobrescribir tailwind.config.js y postcss.config.js? (s/n): " step4
if [[ "$step4" == "s" ]]; then
  cat > tailwind.config.js <<EOF
export default {
  content: ['./index.html', './src/**/*.{js,jsx}'],
  theme: {
    extend: {},
  },
  plugins: [],
}
EOF

  cat > postcss.config.js <<EOF
export default {
  plugins: {
    tailwindcss: {},
    autoprefixer: {},
  },
}
EOF
else
  echo "⏭ Saltando paso 4"
fi

echo "👉 Paso 5: Crear estilos globales"
read -p "¿Crear src/index.css con Tailwind base? (s/n): " step5
if [[ "$step5" == "s" ]]; then
  cat > src/index.css <<EOF
@tailwind base;
@tailwind components;
@tailwind utilities;
EOF
else
  echo "⏭ Saltando paso 5"
fi

echo "👉 Paso 6: Sobrescribir App.jsx y main.jsx con lógica de notas"
read -p "¿Deseas sobrescribir App.jsx y main.jsx? (s/n): " step6
if [[ "$step6" == "s" ]]; then

  cat > src/main.jsx <<EOF
import React from 'react'
import ReactDOM from 'react-dom/client'
import App from './App'
import './index.css'

ReactDOM.createRoot(document.getElementById('root')).render(
  <React.StrictMode>
    <App />
  </React.StrictMode>
)
EOF

  cat > src/App.jsx <<EOF
import React, { useState } from 'react'

const letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('')
const colors = ['bg-yellow-200', 'bg-green-200', 'bg-blue-200']

export default function App() {
  const [notes, setNotes] = useState([])

  const handleAddNote = (letterIndex) => {
    const newNote = {
      id: Date.now(),
      letter: letters[letterIndex],
      color: colors[letterIndex % colors.length],
      text: \`Nota para la letra \${letters[letterIndex]}\`
    }
    setNotes([...notes, newNote])
  }

  return (
    <div className="flex min-h-screen">
      <div className="flex-1 p-4">
        <h1 className="text-2xl font-bold mb-4">Mis Notas</h1>
        <div className="grid gap-4 grid-cols-1 sm:grid-cols-2 md:grid-cols-3">
          {notes.map(note => (
            <div key={note.id} className={\`p-4 rounded shadow \${note.color}\`}>
              <h2 className="font-semibold">{note.letter}</h2>
              <p>{note.text}</p>
            </div>
          ))}
        </div>
      </div>

      <div className="w-14 bg-white shadow-inner border-l border-gray-300 flex flex-col justify-center items-center fixed right-0 top-0 bottom-0 overflow-y-auto">
        {letters.map((letter, index) => (
          <button
            key={letter}
            onClick={() => handleAddNote(index)}
            className={\`w-10 h-10 m-1 text-sm font-bold rounded-full text-white flex items-center justify-center \${{
              0: 'bg-yellow-400',
              1: 'bg-green-500',
              2: 'bg-blue-500',
            }[index % 3]}\`}
          >
            {letter}
          </button>
        ))}
      </div>
    </div>
  )
}
EOF

else
  echo "⏭ Saltando paso 6"
fi

echo "✅ Proyecto 'misnotas-ejemplo' configurado correctamente."
echo "👉 Puedes iniciar con: cd misnotas-ejemplo && npm run dev"
