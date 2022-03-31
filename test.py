import tkinter as tk
from tkinter import ttk


# root window
root = tk.Tk()
root.geometry("300x200")
root.resizable(True, True)
root.title("Slider Demo")


root.columnconfigure(0, weight=1)
root.columnconfigure(1, weight=3)


# slider current value
current_value = tk.IntVar()


def get_current_value():
    return "{}".format(current_value.get())


def slider_changed(event):
    text = get_current_value()
    value_label.configure(text=bin(int(text)))
    print(bin(int(text)))


# label for the slider
slider_label = ttk.Label(root, text="Slider:")

slider_label.grid(column=0, row=0, sticky="w")

#  slider
slider = tk.Scale(root, from_=0, to=511, tickinterval=1, orient="horizontal", command=slider_changed, variable=current_value)  # vertical
slider.grid(column=0, row=1, sticky="we", columnspan=10)

# current value label
current_value_label = ttk.Label(root, text="Current Value:")

current_value_label.grid(row=4, columnspan=2, sticky="n", ipadx=10, ipady=10)

# value label
value_label = ttk.Label(root, text=get_current_value())
value_label.grid(row=2, columnspan=2, sticky="n")


root.mainloop()
