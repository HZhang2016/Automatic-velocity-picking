# -*- coding: utf-8 -*-
"""将生成的速度谱画成二维图，并叠加输出标签 (速度, T0) 对"""
import numpy as np
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt

plt.rcParams['font.sans-serif'] = ['Microsoft YaHei', 'SimHei']
plt.rcParams['axes.unicode_minus'] = False

SAMPLE_ID = 1

# ---------- 读取速度谱输入 ----------
# 修改后的 Start_createdata.m 中: train_inputdata(1,:) = velspectrum(:)
# velspectrum 为 201(t0) x 251(v)，全谱 50451 个值
# 行 = t0 (1:201 -> 0~2.0 s, dt=0.01)，列 = 速度 (1:251 -> 0~5000 m/s, dv=20)
data = np.loadtxt(f'train_inputdata/{SAMPLE_ID}.csv', delimiter=',')
spectrum = data.reshape(201, 251, order='F')   # MATLAB 列优先

v_axis = np.arange(0, 5001, 20)      # 1:251 对应 0~5000 m/s
t_axis = np.arange(0, 2.01, 0.01)    # 1:201 对应 0~2.0 s

# ---------- 读取输出标签 ----------
label = np.loadtxt(f'train_outputdata/{SAMPLE_ID}.csv', delimiter=',')
n_reflect = int(label[18])           # 第 19 个数：界面数 n-1
pairs = label[:2 * n_reflect].reshape(n_reflect, 2)  # (速度, T0)
n_multi = int(label[19])
print(f'界面数 n-1 = {n_reflect}, 多次波个数 = {n_multi}')
print('(速度, T0) 对:')
for v, t in pairs:
    print(f'  v={v:8.1f} m/s,  t0={t:.4f} s')

# ---------- 绘图 ----------
fig, ax = plt.subplots(figsize=(9, 7))
im = ax.imshow(spectrum, aspect='auto', origin='upper',
               extent=[v_axis[0], v_axis[-1], t_axis[-1], t_axis[0]],
               cmap='jet')
cb = fig.colorbar(im, ax=ax, label='叠加能量（白化后）')

# 叠加标签点
ax.scatter(pairs[:, 0], pairs[:, 1], s=140, facecolors='none',
           edgecolors='red', linewidths=2, label='输出标签 (v, t0)')
for i, (v, t) in enumerate(pairs, 1):
    ax.annotate(str(i), (v, t), textcoords='offset points', xytext=(8, 6),
                color='red', fontsize=9, fontweight='bold')

ax.set_xlabel('速度 (m/s)')
ax.set_ylabel('T0 时间 (s)')
ax.set_title(f'样本 {SAMPLE_ID}：速度谱 + 标签 (v, t0) 对')
ax.legend(loc='upper right')
fig.tight_layout()
fig.savefig('velspectrum_with_labels.png', dpi=150)
print('图已保存: velspectrum_with_labels.png')
