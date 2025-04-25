import psutil
import datetime
import time

def monitorear_procesos(top_n=5):
    """Muestra los procesos que más CPU y memoria están consumiendo."""
    # Procesos por uso de CPU
    print("Top procesos por uso de CPU:")
    procesos = []
    for proc in psutil.process_iter(['pid', 'name', 'username', 'cpu_percent', 'memory_percent']):
        procesos.append(proc.info)
    
    # Esperar un segundo para que cpu_percent tenga un valor significativo
    time.sleep(1)
    
    # Actualizar CPU
    for proc in procesos:
        p = psutil.Process(proc['pid'])
        proc['cpu_percent'] = p.cpu_percent()
    
    # Ordenar y mostrar
    procesos_cpu = sorted(procesos, key=lambda x: x['cpu_percent'], reverse=True)[:top_n]
    for i, proc in enumerate(procesos_cpu, 1):
        print(f"{i}. PID: {proc['pid']}, Nombre: {proc['name']}, CPU: {proc['cpu_percent']}%, "
              f"Memoria: {proc['memory_percent']:.2f}%")
    
    print("\nTop procesos por uso de memoria:")
    procesos_mem = sorted(procesos, key=lambda x: x['memory_percent'], reverse=True)[:top_n]
    for i, proc in enumerate(procesos_mem, 1):
        print(f"{i}. PID: {proc['pid']}, Nombre: {proc['name']}, CPU: {proc['cpu_percent']}%, "
              f"Memoria: {proc['memory_percent']:.2f}%")

if __name__ == "__main__":
    print(f"Monitoreo de procesos - {datetime.datetime.now()}")
    print("-" * 50)
    monitorear_procesos(10)  # Mostrar los 10 procesos principales
