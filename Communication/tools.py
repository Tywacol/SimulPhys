class FIFO :
	def __init__(self, size) :
		self.size = size
		self.content = size*[-1]
		self.n = 0

	def addMsg(self, el) :
		if self.content[self.n] == -1 :
			self.content[self.n] = el
			self.n = (self.n + 1) % self.size
		else :
			for i in range(self.size-1) :
				self.content[self.size - (i + 1)] = self.content[self.size - (i + 2)]
			self.content[0] = el

	def getMsgs(self) :
		return self.content
