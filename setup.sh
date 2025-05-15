#!/bin/bash

echo "📁 Verificando si estás dentro del directorio correcto..."
if [ ! -f "./setup-notas.sh" ]; then
  echo "❌ Este script debe ejecutarse dentro del directorio del proyecto (por ejemplo: misnotas-ejemplo)"
  exit 1
fi

# Paso 0: Verificar si package.json existe
if [ ! -f "package.json" ]; then
  echo "📦 No se encontró package.json. ¿Deseas crear un proyecto Vite + React aquí? (s/n): "
  read confirmar
  if [ "$confirmar" = "s" ]; then
    echo "🚀 Creando proyecto Vite + React en el directorio actual..."
    npm create vite@latest . -- --template react
  else
    echo "⏹ Cancelado por el usuario."
    exit 1
  fi
fi

# Paso 1: Instalar dependencias
echo "👉 Paso 1: Instalar dependencias con 'npm install'"
read -p "¿Continuar? (s/n): " confirmar
if [ "$confirmar" = "s" ]; then
  npm install || { echo "❌ Error en npm install"; exit 1; }
else
  echo "⏭ Saltando paso 1"
fi

# Paso 2: Instalar TailwindCSS
echo "👉 Paso 2: Instalar Tailwind CSS y configurar"
read -p "¿Continuar? (s/n): " confirmar
if [ "$confirmar" = "s" ]; then
  npm install -D tailwindcss postcss autoprefixer
  npx tailwindcss init -p
else
  echo "⏭ Saltando paso 2"
fi

# Paso 3: Crear configuración básica Tailwind
echo "👉 Paso 3: Configurar tailwind.config.js"
read -p "¿Continuar? (s/n): " confirmar
if [ "$confirmar" = "s" ]; then
  cat > tailwind.config.js <<EOF
/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {},
  },
  plugins: [],
}
EOF
else
  echo "⏭ Saltando paso 3"
fi

# Paso 4: Reemplazar estilos por defecto
echo "👉 Paso 4: Configurar hoja de estilos"
read -p "¿Continuar? (s/n): " confirmar
if [ "$confirmar" = "s" ]; then
  cat > src/index.css <<EOF
@tailwind base;
@tailwind components;
@tailwind utilities;

body {
  @apply bg-white text-gray-900;
}
EOF
else
  echo "⏭ Saltando paso 4"
fi

# Paso 5: Crear App.jsx básica con barra lateral vertical
echo "👉 Paso 5: Reemplazar App.jsx con plantilla de notas"
read -p "¿Continuar? (s/n): " confirmar
if [ "$confirmar" = "s" ]; then
  cat > src/App.jsx <<'EOF'
import { useState } from 'react';

const letras = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('');
const colores = ['bg-red-100', 'bg-green-100', 'bg-blue-100'];

function Nota({ texto, color }) {
  const fecha = new Date().toLocaleString();
  return (
    <div className={`p-3 my-2 rounded shadow ${color}`}>
      <div className="text-sm text-gray-600">{fecha}</div>
      <div>{texto}</div>
    </div>
  );
}

function App() {
  const [letraActiva, setLetraActiva] = useState('A');
  const [notas, setNotas] = useState({});
  const [input, setInput] = useState('');
  const [colorIndex, setColorIndex] = useState(0);

  const agregarNota = () => {
    if (!input.trim()) return;
    const nueva = { texto: input, color: colores[colorIndex] };
    const nuevasNotas = { ...notas };
    nuevasNotas[letraActiva] = [...(nuevasNotas[letraActiva] || []), nueva];
    setNotas(nuevasNotas);
    setInput('');
    setColorIndex((colorIndex + 1) % colores.length);
  };

  return (
    <div className="flex h-screen">
      <div className="w-16 bg-gray-100 border-l border-gray-300 flex flex-col items-center overflow-y-auto">
        {letras.map((l) => (
          <button
            key={l}
            className={`p-2 m-1 rounded-full hover:bg-gray-300 ${
              letraActiva === l ? 'bg-blue-400 text-white' : ''
            }`}
            onClick={() => setLetraActiva(l)}
          >
            {l}
          </button>
        ))}
      </div>
      <div className="flex-1 p-6 overflow-y-auto">
        <h1 className="text-2xl font-bold mb-4">Notas - Letra {letraActiva}</h1>
        <textarea
          className="w-full h-24 p-2 border border-gray-300 rounded"
          value={input}
          onChange={(e) => setInput(e.target.value)}
          placeholder="Escribe tu nota aquí..."
        />
        <button
          className="mt-2 px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700"
          onClick={agregarNota}
        >
          Agregar Nota
        </button>
        <div className="mt-6">
          {(notas[letraActiva] || []).map((nota, i) => (
            <Nota key={i} {...nota} />
          ))}
        </div>
      </div>
    </div>
  );
}

export default App;
EOF
else
  echo "⏭ Saltando paso 5"
fi

# Paso final: Ejecutar proyecto
echo "✅ Instalación finalizada. ¿Deseas iniciar el servidor con 'npm run dev'? (s/n): "
read confirmar
if [ "$confirmar" = "s" ]; then
  npm run dev
else
  echo "👋 Puedes iniciar el servidor cuando desees con: npm run dev"
fi
