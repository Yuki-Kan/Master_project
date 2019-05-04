from numpy import genfromtxt
import numpy as np
import scipy.io as sio


class CustomTools:
    def read_bank(self):
        data_path = '../Dataset/Bank/Bank32nh/bank32nh.data'
        my_data = genfromtxt(data_path, delimiter=' ')
        attr_length = len(my_data[0, :])
        attr = my_data[:, 0:attr_length-1]
        new_attr = self.normalize_vector(attr)
        labels = my_data[:, attr_length-1:attr_length]
        new_labels = self.make_category(labels)
        return new_attr, new_labels

    def make_category(self, lbls):
        process_data = lbls.copy()
        rows, dim = process_data.shape

        # standardization, mean zero and standard deviation 1
        for i in range(dim):
            mean = process_data[:, i].mean()
            std = process_data[:, i].std()
            process_data[:, i] = (process_data[:, i] - mean) / std

        # make two categories
        for idx in range(len(process_data)):
            if process_data[idx] >= 0:
                process_data[idx] = 1
            else:
                process_data[idx] = 0
        return process_data

    # normalize vector to have norm = 1
    def normalize_vector(self, toy_data):
        vec = toy_data.copy()
        for idx in range(len(vec)):
            norm = np.linalg.norm(vec[idx, :])
            vec[idx, :] = vec[idx, :]/norm
        return vec

    def writing_to_csv(self, attr, label):
        pass


tools = CustomTools()
attr, label = tools.read_bank()
print(attr)
print(label)

dict_attr = {'attr': attr}
sio.savemat('./test_fvec', dict_attr)

dict_lbl = {'label': label}
sio.savemat('./test_label', dict_lbl)


