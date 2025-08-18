import random
import matplotlib.pyplot as plt

p = 0.37
n = 350
simulations = 200
count = []

# Simulación
for _ in range(simulations):
  successes = sum(random.random() < p for _ in range(n))
  count.append(successes)

# Gráfico de histograma
plt.hist(count, bins=15, edgecolor='black')
plt.title(f"Distribución de Éxitos en {simulations} simulaciones\nn={n}, p={p}")
plt.xlabel("Número de éxitos")
plt.ylabel("Frecuencia")
plt.grid(axis='y', alpha=0.75)

# Guardar gráfico
plt.savefig("bernoulli_simulation.png")