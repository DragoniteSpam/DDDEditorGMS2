// status message update
for (var i = array_length(self.status_messages) - 1; i >= 0; i--) {
    if (!self.status_messages[i].Update(48 + 24 * i)) {
        array_delete(self.status_messages, i, 1);
    }
}